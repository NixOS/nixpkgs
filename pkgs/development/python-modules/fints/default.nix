{
  lib,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  fetchFromGitHub,
  bleach,
  mt-940,
  requests,
  sepaxml,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  version = "4.1.0";
  pname = "fints";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "python-fints";
    rev = "v${version}";
    hash = "sha256-1k6ZeYlv0vxNkqQse9vi/NT6ag3DJONKCWB594LvER0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "enum-tools~=0.9.0" ""
    sed -i "/document_enum/d" fints/formals.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    bleach
    mt-940
    requests
    sepaxml
  ];

  pythonImportsCheck = [ "fints" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  meta = with lib; {
    homepage = "https://github.com/raphaelm/python-fints/";
    description = "Pure-python FinTS (formerly known as HBCI) implementation";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [
      dotlambda
    ];
  };
}
