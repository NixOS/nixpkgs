{ lib
, fetchPypi
, buildPythonPackage
, pytestrunner
, numpy
, pyyaml
}:

buildPythonPackage rec {
  pname = "pysrim";
  version = "0.5.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "071c5be48e58fa019f7848588f88ce0a09bfe6493c9ff5987829d162c0f4a497";
  };

  buildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ numpy pyyaml ];

  # Tests require git lfs download of repository
  doCheck = false;

  meta = {
    description = "Srim Automation of Tasks via Python";
    homepage = https://gitlab.com/costrouc/pysrim;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
