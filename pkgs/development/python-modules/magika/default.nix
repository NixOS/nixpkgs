{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
  magika,
  numpy,
  onnxruntime,
  hatchling,
  python-dotenv,
  pythonOlder,
  stdenv,
  tabulate,
  testers,
  tqdm,
}:

buildPythonPackage rec {
  pname = "magika";
  version = "1.0.1";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MT+Mv83Jp+VcJChicyMKJzK4mCXlipPeK1dlMTk7g5g=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    click
    numpy
    onnxruntime
    python-dotenv
    tabulate
    tqdm
  ];

  pythonImportsCheck = [ "magika" ];

  passthru.tests.version = testers.testVersion { package = magika; };

  meta = with lib; {
    description = "Detect file content types with deep learning";
    homepage = "https://github.com/google/magika";
    changelog = "https://github.com/google/magika/blob/python-v${version}/python/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ mihaimaruseac ];
    mainProgram = "magika-python-client";
    # Currently, disabling on AArch64 as it onnx runtime crashes on ofborg
    broken = stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux;
  };
}
