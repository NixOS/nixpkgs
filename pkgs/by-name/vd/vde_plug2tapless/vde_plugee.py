#!/usr/bin/env python

# This is a proof of concept alternative to `vde_plug2tap`.
# Unlike `vde_plug2tap`, it doesn't require a tap interface, it operates on raw sockets.
# This doesn't actually integrate directly with VDE, it's built to be used with `vde_plug`:
#
# $ dpipe vde_plug /tmp/vde1.ctl/ = ./vde_plugee.py
#
# TODO: Reach out to [vde-2] and see if this might be in scope for the project.
#       If they are, port to C and send it to them.
#
# [vde-2]: https://github.com/virtualsquare/vde-2

import threading
import sys
import struct
import argparse
import socket
from typing import BinaryIO

# From netpacket/packet.h
PACKET_ADD_MEMBERSHIP = 1
PACKET_DROP_MEMBERSHIP = 2
PACKET_MR_PROMISC = 1

# From bits/socket.h
SOL_PACKET = 263

# 65,536 is larger than any number on <https://en.wikipedia.org/wiki/Jumbo_frame>.
MTU = 2**16

# Inspired by <https://github.com/secdev/scapy/blob/v2.7.0/scapy/arch/linux/__init__.py#L143-L151>
def set_promisc(s: socket.socket, intf: str, on: bool):
    intf_index = socket.if_nametoindex(intf)
    mreq = struct.pack("IHH8s", intf_index, PACKET_MR_PROMISC, 0, b"")
    if on:
        cmd = PACKET_ADD_MEMBERSHIP
    else:
        cmd = PACKET_DROP_MEMBERSHIP
    s.setsockopt(SOL_PACKET, cmd, mreq)


def shovel_vde_to_bridge(recv_vde: BinaryIO, bridge_socket: socket.socket, debug: bool):
    print("vde -> bridge: shoveling", file=sys.stderr)

    while True:
        # Read frame.
        # The format doesn't seem to be documented anywhere.
        # First, it's the size in 2 octets (network byte order),
        # followed by the raw data.
        # https://github.com/virtualsquare/vde-2/blob/v2.3.3/src/lib/libvdeplug.c#L663-L664
        frame_len_buf = recv_vde.read(2)
        if len(frame_len_buf) == 0:
            print("vde switch seems to have gone away", file=sys.stderr)
            return
        (frame_len,) = struct.unpack("!H", frame_len_buf)
        if debug:
            print(f"vde -> bridge: reading a frame of size {frame_len}", file=sys.stderr)
        raw_frame = recv_vde.read(frame_len)

        # Send frame.
        size = bridge_socket.send(raw_frame)
        if debug:
            print(f"vde -> bridge: send frame of size {size}", file=sys.stderr)

def shovel_bridge_to_vde(bridge_socket: socket.socket, send_vde: BinaryIO, debug: bool):
    print("bridge -> vde: shoveling", file=sys.stderr)

    while True:
        # Read frame.
        raw_frame, _ancdata, flags, _addr = bridge_socket.recvmsg(MTU)
        if flags & socket.MSG_TRUNC:
            assert False, "Ethernet frame was truncated. This shouldn't happen."
        size = len(raw_frame)
        if debug:
            print(f"bridge -> vde: read a frame of size {size}", file=sys.stderr)

        # Send frame.
        send_vde.write(struct.pack("!H", size))
        send_vde.write(raw_frame)
        send_vde.flush()
        if debug:
            print(f"bridge -> vde: wrote a frame of size {size}", file=sys.stderr)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("intf")
    parser.add_argument("--debug", type=bool, default=False)
    args = parser.parse_args()

    bridge_interface = args.intf
    bridge_socket = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.htons(socket.ETH_P_ALL))
    set_promisc(bridge_socket, bridge_interface, on=True)
    bridge_socket.bind((bridge_interface, 0))

    # TODO: Fail faster. Right now, if any of these threads crash, the program keeps running.
    #       Simplest approach is probably to get rid of threads and do asyncio.
    #       Figure out if you're porting this to C first, though.
    threads = [
        # daemon=True ensures that this process actually exits when we get a SIGINT,
        # but we do tend to crash with a SIGBART:
        #
        # > Fatal Python error: _enter_buffered_busy: could not acquire lock for <_io.BufferedReader name='<stdin>'> at interpreter shutdown, possibly due to daemon threads
        # > Python runtime state: finalizing (tstate=0x00007f733fe2bde8)
        # >
        # > Current thread 0x00007f733ff1c780 (most recent call first):
        # >   <no Python frame>
        #
        # The cleanest solution might be to rewrite this to be async rather than using threads.
        threading.Thread(target=lambda: shovel_bridge_to_vde(bridge_socket, sys.stdout.buffer, debug=args.debug), daemon=True),
        threading.Thread(target=lambda: shovel_vde_to_bridge(sys.stdin.buffer, bridge_socket, debug=args.debug), daemon=True),
    ]

    for t in threads:
        t.start()

    for t in threads:
        t.join()

if __name__ == "__main__":
    main()
