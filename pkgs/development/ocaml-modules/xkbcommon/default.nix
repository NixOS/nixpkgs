{
  lib,
  fetchFromGitHub,
  alcotest,
  dune-configurator,
  buildDunePackage,
  libxkbcommon,
  pkg-config,
}:
buildDunePackage {
  pname = "xkbcommon";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "talex5";
    repo = "xkbcommon";
    rev = "bcb74feb2a32a41e612ef28c26755181a9ddcff9";
    hash = "sha256-tyR+X6H7F9U7ylnxoGulmQEe5VANvb0vKqitFT+zxUc=";
  };

  minimalOCamlVersion = "4.14";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dune-configurator
    libxkbcommon
  ];

  checkInputs = [
    alcotest
  ];

  doCheck = true;

  meta = {
    description = "OCaml bindings to libxkbcommon";
    homepage = "https://github.com/talex5/xkbcommon";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ricardomaps ];
  };
}
