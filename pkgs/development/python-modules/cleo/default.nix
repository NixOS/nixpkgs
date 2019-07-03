{ lib, buildPythonPackage, fetchPypi
, pylev, pastel, clikit }:

buildPythonPackage rec {
  pname = "cleo";
  version = "0.7.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d0sxca308ilp73jdny4frn93asr4ih87xxl1d9rxf8m12xssa3c";
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
