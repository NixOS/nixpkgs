{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "capnproto-${version}";
  version = "0.6.1";

  src = fetchurl {
    url = "https://capnproto.org/capnproto-c++-${version}.tar.gz";
    sha256 = "010s9yhq4531wvdfrdf2477zswhck6cjfby79w73rff3v06090l0";
  };

  meta = with stdenv.lib; {
    homepage    = "http://kentonv.github.io/capnproto";
    description = "Cap'n Proto cerealization protocol";
    longDescription = ''
      Cap’n Proto is an insanely fast data interchange format and
      capability-based RPC system. Think JSON, except binary. Or think Protocol
      Buffers, except faster.
    '';
    license     = licenses.bsd2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ cstrahan ];
  };
}
