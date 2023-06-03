import ipaddress
import sys

infs = sys.argv[1:-1]
outf = sys.argv[-1]


def int2ip(ip):
    return str(ipaddress.ip_address(int(ip)))


with open(outf, "w") as out:
    out.write("start_ip,end_ip,country\n")

    for inf in infs:
        with open(inf) as i:
            while line := i.readline():
                if line.startswith("#"):
                    continue
                start_ip, end_ip, country = line.split(",")
                out.write(f"{int2ip(start_ip)},{int2ip(end_ip)},{country}")
