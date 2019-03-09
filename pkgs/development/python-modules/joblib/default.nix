{ lib
, buildPythonPackage
, fetchpatch
, fetchFromGitHub
, sphinx
, numpydoc
, pytest
, python-lz4
}:


buildPythonPackage rec {
  pname = "joblib";
  version = "0.13.2";

  # get full repository inorder to run tests
  src = fetchFromGitHub {
    owner = "joblib";
    repo = pname;
    rev = version;
    sha256 = "11bspmm2is8akcld2kh6bgp0in1ggdy91qsk5zqybzgapc8b4zdf";
  };

  patches = [
    # python-lz4 compatibility
    (fetchpatch {
      url = "https://github.com/joblib/joblib/pull/847.patch";
      sha256 = "0b381d1jzbn6ymj9r859ijk4yk9sd00giv51nqwzbbcmpv17kdas";
    })
  ];

  checkInputs = [ sphinx numpydoc pytest ];
  propagatedBuildInputs = [ python-lz4 ];

  # test_disk_used is broken
  # https://github.com/joblib/joblib/issues/57
  checkPhase = ''
    py.test joblib -k "not test_disk_used"
  '';

  meta = {
    description = "Lightweight pipelining: using Python functions as pipeline jobs";
    homepage = https://pythonhosted.org/joblib/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
