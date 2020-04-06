{ lib, buildPythonPackage, fetchFromGitHub, click, pytest }:

buildPythonPackage rec {
  pname = "click-default-group";
  version = "1.2.2";

  # No tests in Pypi tarball
  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = "click-default-group";
    rev = "v${version}";
    sha256 = "0nk39lmkn208w8kvq6f4h3a6qzxrrvxixahpips6ik3zflbkss86";
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
