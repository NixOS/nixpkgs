{
  lib,
  buildPythonPackage,
  fetchPypi,
  legacy-cgi,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "python-mimeparse";
  version = "1.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "76e4b03d700a641fd7761d3cd4fdbbdcd787eade1ebfac43f877016328334f78";
  };

  dependencies = lib.optionals (pythonAtLeast "3.13") [ legacy-cgi ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Module provides basic functions for parsing mime-type names and matching them against a list of media-ranges";
    homepage = "https://github.com/dbtsai/python-mimeparse";
    license = licenses.mit;
    maintainers = [ ];
  };
}
