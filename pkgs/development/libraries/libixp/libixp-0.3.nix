{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libixp-0.3";
  description = "libixp is a stand-alone client/server 9P library including ixpc client which behaves like wmiir in the past. Its server api is based heavily on Plan 9's lib9p";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.suckless.org/snaps/libixp-0.3.tar.gz;
    md5 = "d341eb9c8f5d233aba5aa2ea8295ca91";
  };
}

