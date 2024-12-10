{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yyjson";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "ibireme";
    repo = "yyjson";
    rev = finalAttrs.version;
    hash = "sha256-iRMjiaVnsTclcdzHjlFOTmJvX3VP4omJLC8AWA/EOZk=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "The fastest JSON library in C";
    homepage = "https://github.com/ibireme/yyjson";
    changelog = "https://github.com/ibireme/yyjson/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.all;
  };
})
