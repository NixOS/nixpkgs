{
  fetchFromGitHub,
  python3Packages,
  lib,
}:
python3Packages.buildPythonApplication rec {
  pname = "zotify";
  version = "0.6.13";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "zotify-dev";
    repo = "zotify";
    # repository has no version tags
    # https://github.com/zotify-dev/zotify/issues/124
    rev = "5da27d32a1f522e80a3129c61f939b1934a0824a";
    hash = "sha256-KA+Q4sk+riaFTybRQ3aO5lgPg4ECZE6G+By+x2uP/VM=";
  };

  build-system = [ python3Packages.setuptools ];

  nativeBuildInputs = [ python3Packages.pythonRelaxDepsHook ];

  pythonRelaxDeps = [ "protobuf" ];

  dependencies = with python3Packages; [
    ffmpy
    music-tag
    pillow
    tabulate
    tqdm
    librespot
    pwinput
    protobuf
  ];

  pythonImportsCheck = [ "zotify" ];

  meta = {
    description = "Fast and customizable music and podcast downloader";
    homepage = "https://github.com/zotify-dev/zotify";
    license = lib.licenses.zlib;
    mainProgram = "zotify";
    maintainers = with lib.maintainers; [ bwkam ];
  };
}
