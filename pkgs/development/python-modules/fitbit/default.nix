{ lib
, buildPythonPackage
, fetchFromGitHub
, coverage
, dateutil
, freezegun
, mock
, requests-mock
, requests_oauthlib
, sphinx
}:

buildPythonPackage rec {
  pname = "fitbit";
  version = "0.3.0";

  checkInputs = [ coverage freezegun mock requests-mock sphinx ];
  propagatedBuildInputs = [ dateutil requests_oauthlib ];

  # The source package on PyPi is missing files required for unit testing.
  # https://github.com/orcasgit/python-fitbit/issues/148
  src = fetchFromGitHub {
    rev = version;
    owner = "orcasgit";
    repo = "python-fitbit";
    sha256 = "0s1kp4qcxvxghqf9nb71843slm4r5lhl2rlvj3yvhbby3cqs4g84";
  };

  postPatch = ''
    substituteInPlace requirements/test.txt \
      --replace 'Sphinx>=1.2,<1.4' 'Sphinx' \
      --replace 'coverage>=3.7,<4.0' 'coverage'
  '';

  meta = with lib; {
    description = "Fitbit API Python Client Implementation";
    license = licenses.asl20;
    homepage = https://github.com/orcasgit/python-fitbit;
    maintainers = with maintainers; [ delroth ];
  };
}
