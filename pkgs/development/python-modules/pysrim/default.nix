{ lib
, fetchPypi
, buildPythonPackage
, pytestrunner
, numpy
, pyyaml
}:

buildPythonPackage rec {
  pname = "pysrim";
  version = "0.5.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c297b4ea6f037946c72e94ddd9a7624cf2fd97c488acbee9409001c970754f1";
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
