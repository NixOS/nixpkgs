{ lib, buildPythonPackage, fetchPypi
, pylev, pastel, clikit }:

buildPythonPackage rec {
  pname = "cleo";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "091nzpfp5incd2fzqych78rvyx4i3djr50cnizbjzr3dc7g00l3s";
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
