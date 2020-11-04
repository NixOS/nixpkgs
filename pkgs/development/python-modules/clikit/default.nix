{ lib, buildPythonPackage, fetchPypi
, isPy27, pythonAtLeast
, pylev, pastel, typing, enum34, crashtest }:

buildPythonPackage rec {
  pname = "clikit";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ngdkmb73gkp5y00q7r9k1cdlfn0wyzws2wrqlshc4hlkbdyabj4";
  };

  propagatedBuildInputs = [
    pylev pastel
  ]
    ++ lib.optionals (pythonAtLeast "3.6") [ crashtest ]
    ++ lib.optionals isPy27 [ typing enum34 ];

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
