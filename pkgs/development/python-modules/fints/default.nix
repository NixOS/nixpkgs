{ stdenv, buildPythonPackage, fetchFromGitHub, isPy27
, bleach
, mt-940
, pytest
, requests
, sepaxml
}:

buildPythonPackage rec {
  version = "2.2.0";
  pname = "fints";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "python-fints";
    rev = "v${version}";
    sha256 = "1gx173dzdprf3jsc7dss0xax8s6l2hr02qg9m5c4rksb3dl5fl8w";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'sepaxml==2.0.*' 'sepaxml~=2.0'
  '';

  propagatedBuildInputs = [ requests mt-940 sepaxml bleach ];

  checkInputs = [ pytest ];

  # ignore network calls and broken fixture
  checkPhase = ''
    pytest . --ignore=tests/test_client.py -k 'not robust_mode'
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/raphaelm/python-fints/;
    description = "Pure-python FinTS (formerly known as HBCI) implementation";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ elohmeier ];
  };
}
