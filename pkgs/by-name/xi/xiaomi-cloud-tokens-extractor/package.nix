{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
let
  pname = "xiaomi-cloud-tokens-extractor";
  version = "1.4.0";
in
python3Packages.buildPythonApplication {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "PiotrMachowski";
    repo = "Xiaomi-cloud-tokens-extractor";
    tag = "v${version}";
    hash = "sha256-ssaNjYB4JkshnMtPjxdiTOa80O3f69ytPLvjRqzx20o=";
  };

  pyproject = false;

  dependencies = with python3Packages; [
    requests
    pycryptodome
    charset-normalizer
    pillow
    colorama
  ];

  dontBuild = true;
  doCheck = false;

  postPatch = ''
    chmod +x token_extractor.py

    # Add shebang so we can patch it
    sed -i -e '1i#!/usr/bin/python' token_extractor.py
    patchShebangs token_extractor.py
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp token_extractor.py "$out/bin/"

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/PiotrMachowski/Xiaomi-cloud-tokens-extractor";
    description = "Retrieves tokens for all devices connected to Xiaomi cloud and encryption keys for BLE devices";
    mainProgram = "token_extractor.py";
    maintainers = with lib.maintainers; [ MakiseKurisu ];
    license = lib.licenses.mit;
  };
}
