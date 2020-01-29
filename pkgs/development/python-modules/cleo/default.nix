{ lib, buildPythonPackage, fetchPypi
, pylev, pastel, clikit }:

buildPythonPackage rec {
  pname = "cleo";
  version = "0.7.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "99cf342406f3499cec43270fcfaf93c126c5164092eca201dfef0f623360b409";
  };

  propagatedBuildInputs = [
    clikit
  ];

  # The Pypi tarball doesn't include tests, and the GitHub source isn't
  # buildable until we bootstrap poetry, see
  # https://github.com/NixOS/nixpkgs/pull/53599#discussion_r245855665
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/sdispater/cleo;
    description = "Allows you to create beautiful and testable command-line interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
