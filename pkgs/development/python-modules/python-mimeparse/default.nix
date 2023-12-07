{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-mimeparse";
  version = "1.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "76e4b03d700a641fd7761d3cd4fdbbdcd787eade1ebfac43f877016328334f78";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A module provides basic functions for parsing mime-type names and matching them against a list of media-ranges";
    homepage = "https://github.com/dbtsai/python-mimeparse";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
