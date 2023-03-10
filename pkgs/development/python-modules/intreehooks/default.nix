{ lib
, buildPythonPackage
, fetchPypi
, pytoml
, pytest
}:

buildPythonPackage rec {
  pname = "intreehooks";
  version = "1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "87e600d3b16b97ed219c078681260639e77ef5a17c0e0dbdd5a302f99b4e34e1";
  };

  propagatedBuildInputs = [ pytoml ];

  nativeCheckInputs = [ pytest ];

  meta = {
    description = "Load a PEP 517 backend from inside the source tree";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.fridh ];
    homepage = "https://github.com/takluyver/intreehooks";
  };
}
