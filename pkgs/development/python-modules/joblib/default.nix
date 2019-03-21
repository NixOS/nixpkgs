{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
, numpydoc
, pytest
, python-lz4
}:


buildPythonPackage rec {
  pname = "joblib";
  version = "0.12.4";

  # get full repository inorder to run tests
  src = fetchFromGitHub {
    owner = "joblib";
    repo = pname;
    rev = version;
    sha256 = "06zszgp7wpa4jr554wkk6kkigp4k9n5ad5h08i6w9qih963rlimb";
  };

  checkInputs = [ sphinx numpydoc pytest ];
  propagatedBuildInputs = [ python-lz4 ];

  checkPhase = ''
    py.test joblib
  '';

  meta = {
    description = "Lightweight pipelining: using Python functions as pipeline jobs";
    homepage = https://pythonhosted.org/joblib/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
