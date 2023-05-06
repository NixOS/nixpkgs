{ lib, buildPythonPackage, fetchPypi
, pytest-runner
, setuptools
, coverage, pytest
}:

buildPythonPackage rec {
  pname = "diceware";
  version = "0.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-srTMm1n1aNLvUb/fn34a+UHSX7j1wl8XAZHburzpZWk=";
  };

  nativeBuildInputs = [ pytest-runner ];

  propagatedBuildInputs = [ setuptools ];

  nativeCheckInputs = [ coverage pytest ];

  # see https://github.com/ulif/diceware/commit/a7d844df76cd4b95a717f21ef5aa6167477b6733
  checkPhase = ''
    py.test -m 'not packaging'
  '';

  meta = with lib; {
    description = "Generates passphrases by concatenating words randomly picked from wordlists";
    homepage = "https://github.com/ulif/diceware";
    license = licenses.gpl3;
    maintainers = with maintainers; [ asymmetric ];
  };
}
