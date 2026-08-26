{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytube";
  version = "15.0.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pytube";
    repo = "pytube";
    rev = "v${version}";
    hash = "sha256-Nvs/YlOjk/P5nd1kpUnCM2n6yiEaqZP830UQI0Ug1rk=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [ "test_streaming" ];

  disabledTestPaths = [
    "tests/test_extract.py"
    "tests/test_query.py"
    "tests/test_streams.py"
    "tests/test_main.py"
  ];

  pythonImportsCheck = [ "pytube" ];

  meta = {
    description = "Python 3 library for downloading YouTube Videos";
    mainProgram = "pytube";
    homepage = "https://github.com/nficano/pytube";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
