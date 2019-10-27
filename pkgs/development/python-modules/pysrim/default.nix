{ lib
, fetchPypi
, buildPythonPackage
, pytestrunner
, numpy
, pyyaml
}:

buildPythonPackage rec {
  pname = "pysrim";
  version = "0.5.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ada088f73f7e1a3bf085206e81e0f83ed89c1d0b23a789ecd0ba0a250724aee8";
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
