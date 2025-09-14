{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "verdict";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "sandialabs";
    repo = "verdict";
    tag = finalAttrs.version;
    hash = "sha256-VrjyAMou5BajOIb13RjEqVgOsDcllfzI/OJ81fyILjs=";
  };

  nativeBuildInputs = [
    cmake
  ];

  nativeCheckInputs = [
    gtest
  ];

  doCheck = true;

  meta = {
    description = "Compute functions of 2- and 3-dimensional regions";
    homepage = "https://github.com/sandialabs/verdict";
    license = lib.licenses.bsd3;
    changelog = "https://github.com/sandialabs/verdict/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
  };
})
