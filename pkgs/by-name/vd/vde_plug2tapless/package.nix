{
  lib,
  vde2,
  python3,
  writeShellApplication,
}:
writeShellApplication {
  name = "vde_plug2tapless";
  runtimeInputs = [ vde2 ];
  text = ''
    if [ $# -ne 2 ]; then
        echo "Usage: $0 [vde_socket_dir] [intf]" >&2
        echo "Example: $0 /tmp/vde1.ctl/ br0" >&2
        exit 1
    fi

    vde_socket_dir=$1
    intf=$2

    exec dpipe vde_plug "$vde_socket_dir" = ${lib.getExe python3} ${./vde_plugee.py} "$intf"
  '';
}
