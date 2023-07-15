{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "diceware";
  version = "0.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-srTMm1n1aNLvUb/fn34a+UHSX7j1wl8XAZHburzpZWk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest_runner'," ""
  '';

  propagatedBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # see https://github.com/ulif/diceware/commit/a7d844df76cd4b95a717f21ef5aa6167477b6733
    "-m 'not packaging'"
  ];

  pythonImportsCheck = [
    "diceware"
  ];

  meta = with lib; {
    description = "Generates passphrases by concatenating words randomly picked from wordlists";
    homepage = "https://github.com/ulif/diceware";
    changelog = "https://github.com/ulif/diceware/blob/v${version}/CHANGES.rst";
    license = licenses.gpl3;
    maintainers = with maintainers; [ asymmetric ];
  };
}
