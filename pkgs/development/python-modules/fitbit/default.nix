{ lib
, buildPythonPackage
, fetchFromGitHub
, coverage
, python-dateutil
, freezegun
, mock
, requests-mock
, requests_oauthlib
, sphinx
}:

buildPythonPackage rec {
  pname = "fitbit";
  version = "0.3.1";

  checkInputs = [ coverage freezegun mock requests-mock sphinx ];
  propagatedBuildInputs = [ python-dateutil requests_oauthlib ];

  # The source package on PyPi is missing files required for unit testing.
  # https://github.com/orcasgit/python-fitbit/issues/148
  src = fetchFromGitHub {
    rev = version;
    owner = "orcasgit";
    repo = "python-fitbit";
    sha256 = "1w2lpgf6bs5nbnmslppaf4lbhr9cj6grg0a525xv41jip7iy3vfn";
  };

  postPatch = ''
    substituteInPlace requirements/test.txt \
      --replace 'Sphinx>=1.2,<1.4' 'Sphinx' \
      --replace 'coverage>=3.7,<4.0' 'coverage'
  '';

  meta = with lib; {
    description = "Fitbit API Python Client Implementation";
    license = licenses.asl20;
    homepage = "https://github.com/orcasgit/python-fitbit";
    maintainers = with maintainers; [ delroth ];
  };
}
