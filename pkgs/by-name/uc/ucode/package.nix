{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  json_c,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ucode";
  version = "0.0.20250529";

  src = fetchFromGitHub {
    owner = "jow-";
    repo = "ucode";
    rev = "v${finalAttrs.version}";
    hash = "sha256-V8WGd4rSuCtGIA5oTfnagp0Dmh5FNG87/MJSeILtbM4=";
  };

  buildInputs = [
    json_c
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = {
    description = "JavaScript-like language with optional templating";
    homepage = "https://github.com/jow-/ucode";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mkg20001 ];
  };
})
