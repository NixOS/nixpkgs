{ lib
, buildPythonPackage
, fetchPypi
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "regex";
  version = "2022.10.31";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o6mJIdqaG/hFeu7mpVGUioNgFonl7N1zaJTqm77HfoM=";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  pythonImportsCheck = [
    "regex"
  ];

  meta = with lib; {
    description = "Alternative regular expression module, to replace re";
    homepage = "https://bitbucket.org/mrabarnett/mrab-regex";
    license = licenses.psfl;
    maintainers = with maintainers; [ abbradar ];
  };
}
