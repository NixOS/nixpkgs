{ lib
, buildPythonPackage
, fetchPypi
, docutils
}:

buildPythonPackage rec {
  pname = "Pygments";
  version = "2.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a";
  };

  propagatedBuildInputs = [ docutils ];

  # Circular dependency with sphinx
  doCheck = false;
  pythonImportsCheck = [ "pygments" ];

  meta = {
    homepage = "https://pygments.org/";
    description = "A generic syntax highlighter";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
  };
}
