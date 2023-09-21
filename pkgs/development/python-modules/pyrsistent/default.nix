{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, six
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "pyrsistent";
  version = "0.19.3";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GimUdzcGu7SZXDGpe8lPFBgxSSO9EEjG2WSDcEA3ZEA=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook hypothesis ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'pytest<5' 'pytest' \
      --replace 'hypothesis<5' 'hypothesis'
  '';

  pythonImportsCheck = [ "pyrsistent" ];

  meta = with lib; {
    homepage = "https://github.com/tobgu/pyrsistent/";
    description = "Persistent/Functional/Immutable data structures";
    license = licenses.mit;
    maintainers = with maintainers; [ desiderius ];
  };

}
