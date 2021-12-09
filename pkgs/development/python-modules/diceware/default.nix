{ lib, buildPythonPackage, fetchFromGitHub
, pytest-runner
, setuptools
, coverage, pytest
}:

buildPythonPackage rec {
  pname = "diceware";
  version = "0.9.6";

  src = fetchFromGitHub {
     owner = "ulif";
     repo = "diceware";
     rev = "v0.9.6";
     sha256 = "14z94wjdcnz4lvb7r0dsfx8qjndmxkc55dn5qy1namqs01s8n1hd";
  };

  nativeBuildInputs = [ pytest-runner ];

  propagatedBuildInputs = [ setuptools ];

  checkInputs = [ coverage pytest ];

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
