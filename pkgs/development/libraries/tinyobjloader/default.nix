{ lib, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "tinyobjloader";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "tinyobjloader";
    repo = "tinyobjloader";
    rev = "v${version}";
    sha256 = "162168995f4xch7hm3iy6m57r8iqkpzi5x9qh1gsghlxwdxxqbis";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/tinyobjloader/tinyobjloader";
    description = "Tiny but powerful single file wavefront obj loader";
    license = licenses.mit;
    maintainers = [ maintainers.ivar ];
    platforms = platforms.all;
  };
}
