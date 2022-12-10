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
  version = "0.18.1";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1NYfi5k6clW6cU3zrKUnAPgSUon4T3BM+AkWUXxG65Y=";
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
