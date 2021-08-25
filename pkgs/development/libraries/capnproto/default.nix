{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "capnproto";
  version = "0.9.0";

  src = fetchurl {
    url = "https://capnproto.org/capnproto-c++-${version}.tar.gz";
    sha256 = "sha256-soBUp6K/6kK/w5LI0AljDZTXLozoaiOtbxi15yV0Bk8=";
  };

  meta = with lib; {
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
