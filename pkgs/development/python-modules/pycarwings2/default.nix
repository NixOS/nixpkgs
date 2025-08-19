{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  iso8601,
  requests,
  pycryptodome,
}:

buildPythonPackage rec {
  pname = "pycarwings2";
  version = "2.14";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "filcole";
    repo = "pycarwings2";
    rev = "v${version}";
    hash = "sha256-kqj/NZXqgPUsOnnzMPmIlICHek7RBxksmL3reNBK+bo=";
  };

  propagatedBuildInputs = [
    pyyaml
    iso8601
    requests
    pycryptodome
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
    substituteInPlace setup.cfg \
      --replace " --flake8 --cov=pycarwings2 --cache-clear --ignore=venv --verbose" ""
  '';

  disabledTests = [
    # Test requires network access
    "test_bad_password"
  ];

  pythonImportsCheck = [ "pycarwings2" ];

  meta = with lib; {
    description = "Python library for interacting with the NissanConnect EV";
    homepage = "https://github.com/filcole/pycarwings2";
    changelog = "https://github.com/filcole/pycarwings2/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
