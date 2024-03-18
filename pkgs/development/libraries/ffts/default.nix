{ stdenv, cmake, git, lib, fetchFromGitHub,
  ... }:
stdenv.mkDerivation rec {
  pname = "ffts";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "anthonix";
    repo = "ffts";
    rev = "fe86885ecafd0d16eb122f3212403d1d5a86e24e";
    hash = "sha256-arBXkEbKGd0y6XpyynUSFQmNs7fndhEK7y1NNZI9MnI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake git ];
  buildInputs = [  ];

  cmakeFlags = [
    "-DCURRENT_GIT_VERSION=${lib.substring 0 7 src.rev}"
    "-DENABLE_SHARED=ON"
    "-Wno-deprecated"
  ];

  meta = with lib; {
    description = "The Fastest Fourier Transform in the South";
    homepage = "http://anthonix.com/ffts";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ thoughtpolice hansfbaier ];
    platforms = lib.platforms.linux;
  };
}
