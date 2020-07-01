{ lib, buildPythonPackage, fetchPypi
, pylev, pastel, clikit }:

buildPythonPackage rec {
  pname = "cleo";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d0e22d30117851b45970b6c14aca4ab0b18b1b53c8af57bed13208147e4069f";
  };

  propagatedBuildInputs = [
    clikit
  ];

  # The Pypi tarball doesn't include tests, and the GitHub source isn't
  # buildable until we bootstrap poetry, see
  # https://github.com/NixOS/nixpkgs/pull/53599#discussion_r245855665
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/sdispater/cleo";
    description = "Allows you to create beautiful and testable command-line interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
