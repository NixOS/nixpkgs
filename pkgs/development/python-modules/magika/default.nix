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
  version = "0.6.2";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N+tq6AIPbmjyMbwGBSwKDL6Ob6J0kts0Xo3IZ9vOsGc=";
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

  # Imports in the build sandbox on aarch64-linux, but the program still works at
  # runtime. See https://github.com/microsoft/onnxruntime/issues/10038.
  pythonImportsCheck = lib.optionals (stdenv.system != "aarch64-linux") [ "magika" ];

  passthru.tests.version = testers.testVersion { package = magika; };

  meta = with lib; {
    description = "Detect file content types with deep learning";
    homepage = "https://github.com/google/magika";
    changelog = "https://github.com/google/magika/blob/python-v${version}/python/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ mihaimaruseac ];
    mainProgram = "magika-python-client";
  };
}
