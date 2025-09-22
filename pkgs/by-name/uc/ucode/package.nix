{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  json_c,
}:

stdenv.mkDerivation rec {
  pname = "ucode";
  version = "0.0.20250529";

  src = fetchFromGitHub {
    owner = "jow-";
    repo = "ucode";
    rev = "v${version}";
    hash = "sha256-V8WGd4rSuCtGIA5oTfnagp0Dmh5FNG87/MJSeILtbM4=";
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
