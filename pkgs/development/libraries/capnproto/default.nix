{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "capnproto";
  version = "0.8.0";

  src = fetchurl {
    url = "https://capnproto.org/capnproto-c++-${version}.tar.gz";
    sha256 = "03f1862ljdshg7d0rg3j7jzgm3ip55kzd2y91q7p0racax3hxx6i";
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
