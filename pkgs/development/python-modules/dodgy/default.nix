{ buildPythonPackage
, fetchFromGitHub
, isPy3k
, lib

# pythonPackages
, mock
, nose
}:

buildPythonPackage rec {
  pname = "dodgy";
  version = "0.2.1";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "landscapeio";
    repo = pname;
    rev = version;
    sha256 = "0ywwjpz0p6ls3hp1lndjr9ql6s5lkj7dgpll1h87w04kwan70j0x";
  };

  nativeCheckInputs = [
    mock
    nose
  ];

  checkPhase = ''
    nosetests tests/test_checks.py
  '';

  meta = with lib; {
    description = "Looks at Python code to search for things which look \"dodgy\" such as passwords or diffs";
    homepage = "https://github.com/landscapeio/dodgy";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
