{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, pytestCheckHook
, mock
, pyyaml
, six
}:

buildPythonPackage rec {
  pname = "python-multipart";
  version = "0.0.6";
  format = "pyproject";

  src = fetchPypi {
    pname = "python_multipart";
    inherit version;
    hash = "sha256-6ZJagLtmhSnxtnx/2wpdrN18v8b7C/8+pEP+Ir3WITI=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    six
  ];

  pythonImportsCheck = [
    "multipart"
  ];

  preCheck = ''
    # https://github.com/andrew-d/python-multipart/issues/41
    substituteInPlace multipart/tests/test_multipart.py \
      --replace "yaml.load" "yaml.safe_load"
  '';

  nativeCheckInputs = [
    pytestCheckHook
    mock
    pyyaml
  ];

  meta = with lib; {
    description = "A streaming multipart parser for Python";
    homepage = "https://github.com/andrew-d/python-multipart";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
