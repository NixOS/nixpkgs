{ lib, buildPythonPackage, fetchPypi
, isPy27
, pylev, pastel, typing, enum34 }:

buildPythonPackage rec {
  pname = "clikit";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0603e3c19fa106f5df5f224826c92e57221f48ec969e42744173e0458d359354";
  };

  propagatedBuildInputs = [
    pylev pastel
  ] ++ lib.optionals isPy27 [ typing enum34 ];

  # The Pypi tarball doesn't include tests, and the GitHub source isn't
  # buildable until we bootstrap poetry, see
  # https://github.com/NixOS/nixpkgs/pull/53599#discussion_r245855665
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/sdispater/clikit";
    description = "A group of utilities to build beautiful and testable command line interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
