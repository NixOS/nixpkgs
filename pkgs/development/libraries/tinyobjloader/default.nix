{ lib, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "tinyobjloader";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "tinyobjloader";
    repo = "tinyobjloader";
    rev = "v${version}";
    sha256 = "sha256-BNffbicnLTGK2GQ2/bB328LFU9fqHxrpAVj2hJaekWc=";
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
