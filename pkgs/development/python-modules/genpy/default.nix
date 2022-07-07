{ lib
, buildPythonPackage
, fetchPypi
, pytools
, numpy
}:

buildPythonPackage rec {
  pname = "genpy";
  version = "2021.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9bc062fa98c5c466ff464d8974be81a6bf67af9247b5e5176215ad1e81a6cdac";
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
