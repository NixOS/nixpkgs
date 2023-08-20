{ lib
, buildPythonPackage
, unittestCheckHook
, fetchPypi
, pythonOlder
, glibcLocales
}:

buildPythonPackage rec {
  pname = "pystache";
  version = "0.6.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4CkCIzBJsW4L4alPDHOJ6AViX2c1eD9FM7AgtaOKJ8c=";
  };

  LC_ALL = "en_US.UTF-8";

  buildInputs = [
    glibcLocales
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "pystache"
  ];

  meta = with lib; {
    description = "A framework-agnostic, logic-free templating system inspired by ctemplate and et";
    homepage = "https://github.com/defunkt/pystache";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
