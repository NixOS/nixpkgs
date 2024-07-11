{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "overpy";
  version = "0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "DinoTools";
    repo = "python-overpy";
    rev = version;
    hash = "sha256-Tl+tzxnPASL4J6D/BYCEWhXe/mI12OVgNT5lyby3s7A=";
  };

  patches = [
    (fetchpatch {
      # Remove pytest-runner
      url = "https://patch-diff.githubusercontent.com/raw/DinoTools/python-overpy/pull/104.patch";
      hash = "sha256-ScS0vd2P+wyQGyCQV6/4cUcqoQ+S07tGpEovuz9oBMw=";
    })
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "overpy" ];

  meta = with lib; {
    description = "Python Wrapper to access the Overpass API";
    homepage = "https://github.com/DinoTools/python-overpy";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
