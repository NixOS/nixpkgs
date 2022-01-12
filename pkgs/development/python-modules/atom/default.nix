{ lib, buildPythonPackage, fetchPypi, future, cppy }:

buildPythonPackage rec {
  pname = "atom";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4055fbdeeb692d3d52c6e3c628d7513fc71f147920cac7d0da05b6dbb5ec8c8d";
  };

  buildInputs = [ cppy ];
  propagatedBuildInputs = [ future ];

  # Tests not released to pypi
  doCheck = true;

  meta = with lib; {
    description = "Memory efficient Python objects";
    maintainers = [ maintainers.bhipple ];
    homepage = "https://github.com/nucleic/atom";
    license = licenses.bsd3;
  };
}
