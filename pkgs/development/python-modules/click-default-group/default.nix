{ lib, buildPythonPackage, fetchFromGitHub, click, pytest }:

buildPythonPackage rec {
  pname = "click-default-group";
  version = "1.2";

  # No tests in Pypi tarball
  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-default-group";
    rev = "v${version}";
    sha256 = "0lm2k4jvy4ilvv91niawklfnp5mp7wa8c1bicsqdfzrxmw7jliwp";
  };

  propagatedBuildInputs = [ click ];

  checkInputs = [ pytest ];

  meta = with lib; {
    homepage = https://github.com/click-contrib/click-default-group;
    description = "Group to invoke a command without explicit subcommand name";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
