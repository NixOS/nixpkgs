{ stdenv, buildPythonPackage, fetchFromGitHub, isPy27
, bleach
, mt-940
, pytest
, requests
, sepaxml
}:

buildPythonPackage rec {
  version = "3.0.0";
  pname = "fints";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "python-fints";
    rev = "v${version}";
    sha256 = "00fqgnmv7z6d792ga4cyzn9lrfjf79jplkssm2jbyb0akfggfj7h";
  };

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
