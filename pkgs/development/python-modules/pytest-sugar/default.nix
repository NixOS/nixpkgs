{ lib
, buildPythonPackage
, fetchPypi
, termcolor
, pytest
, packaging
}:

buildPythonPackage rec {
  pname = "pytest-sugar";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fcd87a74b2bce5386d244b49ad60549bfbc4602527797fac167da147983f58ab";
  };

  propagatedBuildInputs = [
    termcolor
    pytest
    packaging
  ];

  meta = with lib; {
    description = "A plugin that changes the default look and feel of py.test";
    homepage = https://github.com/Frozenball/pytest-sugar;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
