{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  hdf5,
  numpy,
  opencv-python-headless,
  pillow,
  pyaml,
  pyclipper,
  python-bidi,
  pythonOlder,
  scikit-image,
  scipy,
  shapely,
  torch,
  torchvision,
  python,
}:

buildPythonPackage rec {
  pname = "easyocr";
  version = "1.7.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JaidedAI";
    repo = "EasyOCR";
    tag = "v${version}";
    hash = "sha256-9mrAxt2lphYtLW81lGO5SYHsnMnSA/VpHiY2NffD/Js=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "torchvision"
  ];

  pythonRemoveDeps = [
    "ninja"
  ];

  dependencies = [
    hdf5
    numpy
    opencv-python-headless
    pillow
    pyaml
    pyclipper
    python-bidi
    scikit-image
    scipy
    shapely
    torch
    torchvision
  ];

  checkPhase = ''
    runHook preCheck

    export HOME="$(mktemp -d)"
    pushd unit_test
    ${python.interpreter} run_unit_test.py --easyocr "$out/${python.sitePackages}/easyocr"
    popd

    runHook postCheck
  '';

  # downloads detection model from the internet
  doCheck = false;

  pythonImportsCheck = [ "easyocr" ];

  meta = with lib; {
    description = "Ready-to-use OCR with 80+ supported languages and all popular writing scripts";
    mainProgram = "easyocr";
    homepage = "https://github.com/JaidedAI/EasyOCR";
    changelog = "https://github.com/JaidedAI/EasyOCR/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
