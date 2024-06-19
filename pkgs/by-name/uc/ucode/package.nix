{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, json_c
}:

stdenv.mkDerivation rec {
  pname = "ucode";
  version = "0.0.20231102";

  src = fetchFromGitHub {
    owner = "jow-";
    repo = "ucode";
    rev = "v${version}";
    hash = "sha256-dJjlwuQLS73D6W/bmhWLPPaT7himQyO1RvD+MXVxBMw=";
  };

  buildInputs = [
    json_c
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = with lib; {
    description = "JavaScript-like language with optional templating";
    homepage = "https://github.com/jow-/ucode";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
