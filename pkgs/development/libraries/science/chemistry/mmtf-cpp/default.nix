{ stdenv, lib, fetchFromGitHub, cmake, msgpack } :

stdenv.mkDerivation rec {
  pname = "mmtf-cpp";
  version = "1.1.0";

  src = fetchFromGitHub  {
    owner = "rcsb";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8JrNobvekMggS8L/VORKA32DNUdXiDrYMObjd29wQmc=";
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
