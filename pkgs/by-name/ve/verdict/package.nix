{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "verdict";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "sandialabs";
    repo = "verdict";
    tag = finalAttrs.version;
    hash = "sha256-8RUFag3XsWsrvVXsz/+ARTHfmGAJ6giQApn+XDwslMQ=";
  };

  nativeBuildInputs = [
    cmake
  ];

  nativeCheckInputs = [
    gtest
  ];

  doCheck = true;

  meta = with lib; {
    description = "Compute functions of 2- and 3-dimensional regions";
    homepage = "https://github.com/sandialabs/verdict";
    license = licenses.bsd3;
    changelog = "https://github.com/sandialabs/verdict/releases/tag/${finalAttrs.version}";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
  };
})
