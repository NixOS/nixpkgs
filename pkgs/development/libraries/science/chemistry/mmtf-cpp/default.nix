{ stdenv, lib, fetchFromGitHub, cmake, msgpack } :

stdenv.mkDerivation rec {
  pname = "mmtf-cpp";
  version = "1.0.0";

  src = fetchFromGitHub  {
    owner = "rcsb";
    repo = pname;
    rev = "v${version}";
    sha256= "17ylramda69plf5w0v5hxbl4ggkdi5s15z55cv0pljl12yvyva8l";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ msgpack ];

  meta = with lib; {
    description = "A library of exchange-correlation functionals with arbitrary-order derivatives";
    homepage = "https://github.com/rcsb/mmtf-cpp";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
