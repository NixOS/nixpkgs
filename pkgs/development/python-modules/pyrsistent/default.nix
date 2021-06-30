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
  version = "0.17.3";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e636185d9eb976a18a8a8e96efce62f2905fea90041958d8cc2a189756ebf3e";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestCheckHook hypothesis ];

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
