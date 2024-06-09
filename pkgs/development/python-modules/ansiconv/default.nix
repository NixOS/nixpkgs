{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
}:

buildPythonPackage rec {
  pname = "ansiconv";
  version = "1.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ansible";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ljfpl8x069arzginvpi1v6hlaq4x2qpjqj01qds2ylz33scq8r4";
  };

  nativeCheckInputs = [ pytest ];

  meta = with lib; {
    description = "A module for converting ANSI coded text and converts it to either plain text or HTML";
    homepage = "https://github.com/ansible/ansiconv";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
