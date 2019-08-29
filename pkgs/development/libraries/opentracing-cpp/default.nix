{ stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  name = "opentracing-cpp-${version}";
  version = "1.5.1";
  src = fetchFromGitHub {
    owner = "opentracing";
    repo = "opentracing-cpp";
    rev = "v${version}";
    sha256 = "04kw19g8qrv3kd40va3sqbfish7kfczkdpxdwraifk9950wfs3gx";
  };
  buildInputs = [ cmake ];

  meta = {
    description = "C++ implementation of the OpenTracing API";
    homepage = https://opentracing.io;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ rob ];
  };

}
