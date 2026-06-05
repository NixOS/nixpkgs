{
  lib,
  buildPythonPackage,
  fetchPypi,
  bce-python-sdk,
  requests,
  tqdm,
  psutil,
  click,
  prettytable,
}:

let
  version = "0.3.8";

  format = "wheel";
in
buildPythonPackage {
  pname = "aistudio-sdk";
  inherit version format;

  # No source code dist available
  src = fetchPypi {
    pname = "aistudio_sdk";
    inherit version format;
    dist = "py3";
    python = "py3";
    hash = "sha256-v8lq9yQ6wu4zAwFISapAKHF8zlr6Yir4z+Oh1E0ZQdY=";
  };

  dependencies = [
    bce-python-sdk
    requests
    tqdm
    # Implicit dependency for file_download.py
    psutil
    # `aistudio` binary dependencies
    click
    prettytable
  ];

  pythonImportsCheck = [ "aistudio_sdk" ];

  meta = {
    description = "Python client library for the AIStudio API";
    homepage = "https://pypi.org/project/aistudio-sdk";
    license = lib.licenses.unfree;
    mainProgram = "aistudio";
    maintainers = with lib.maintainers; [ kyehn ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
