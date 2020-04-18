
{ buildPythonPackage
, fetchFromGitHub
, isPy37
, lib

# Python Dependencies
, mock
, pytest
, six
}:

buildPythonPackage rec {
  pname = "mixpanel";
  version = "4.5.0";
  disabled = !isPy37;

  src = fetchFromGitHub {
    owner = "mixpanel";
    repo = "mixpanel-python";
    rev = version;
    sha256 = "1hlc717wcn71i37ngsfb3c605rlyjhsn3v6b5bplq00373r4d39z";
  };

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    mock
    pytest
  ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    homepage = "https://github.com/mixpanel/mixpanel-python";
    description = "Official Mixpanel Python library";
    license = licenses.asl20;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
