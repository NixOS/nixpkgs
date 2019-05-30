{ lib, buildPythonPackage, fetchPypi
, pylev, pastel, clikit }:

buildPythonPackage rec {
  pname = "cleo";
  version = "0.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "58d26642fa608a1515093275cd98875100c7d50f01fc1f3bbb7a78dbb73e4b14";
  };

  propagatedBuildInputs = [
    pylev
    pastel
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
