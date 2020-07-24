{ lib
, buildPythonPackage
, fetchPypi
, pytools
, numpy
}:

buildPythonPackage rec {
  pname = "genpy";
  version = "2016.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c11726f1e8ace8bbdfc87816403c9a59f53a8c3d45c99187ae17c9725d87a91";
  };

  propagatedBuildInputs = [
    pytools
    numpy
  ];

  meta = with lib; {
    description = "C/C++ source generation from an AST";
    homepage = "https://github.com/inducer/genpy";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
