{ lib, buildPythonPackage, fetchPypi
, isPy27, isPy34
, pylev, pastel, typing, enum34 }:

buildPythonPackage rec {
  pname = "clikit";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0glppxx0pyppjcigzs8h16srlbxb6nci0282xfy3ayvwbq8pwbbf";
  };

  propagatedBuildInputs = [
    pylev pastel
  ] ++ lib.optional (isPy27 || isPy34) typing
    ++ lib.optional isPy27 enum34;

  # The Pypi tarball doesn't include tests, and the GitHub source isn't
  # buildable until we bootstrap poetry, see
  # https://github.com/NixOS/nixpkgs/pull/53599#discussion_r245855665
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/sdispater/clikit;
    description = "A group of utilities to build beautiful and testable command line interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
