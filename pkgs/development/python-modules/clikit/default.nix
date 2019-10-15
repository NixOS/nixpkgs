{ lib, buildPythonPackage, fetchPypi
, isPy27, isPy34
, pylev, pastel, typing, enum34 }:

buildPythonPackage rec {
  pname = "clikit";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pvzq3glf4sjgrm0wyxln3s6vicdc9q8r5sgaiqmxdmd9pylw0xm";
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
