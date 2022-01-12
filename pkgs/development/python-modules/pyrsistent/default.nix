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
  version = "0.18.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "773c781216f8c2900b42a7b638d5b517bb134ae1acbebe4d1e8f1f41ea60eb4b";
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
