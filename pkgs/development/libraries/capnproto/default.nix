{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "capnproto-0.4.1";

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

  src = fetchurl {
    url = "https://capnproto.org/capnproto-c++-0.4.1.tar.gz";
    sha256 = "8453e8d508906062f113dbdfff552f41e08083ccf7c9407778a8d107675cd468";
  };
}
