{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, mock
, pyyaml
, six
}:

buildPythonPackage rec {
  pname = "python-multipart";
  version = "0.0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f7bb5f611fc600d15fa47b3974c8aa16e93724513b49b5f95c81e6624c83fa43";
  };

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
    maintainers = with maintainers; [ costrouc ];
  };
}
