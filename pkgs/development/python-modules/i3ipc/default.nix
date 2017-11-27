{ lib, fetchFromGitHub, buildPythonPackage, enum-compat }:

let
  version = "1.3.0";
  sha256 = "1rw9mq18np6bf8xp8vvc21bi5q8xjmj8dck2vsa1hy8bk434259m";

in buildPythonPackage rec {
  pname = "i3ipc";
  inherit version;

  src = fetchFromGitHub {
    owner = "acrisci";
    repo = "i3ipc-python";
    rev = "refs/tags/v${version}";
    inherit sha256;
    fetchSubmodules = true; # Fetching by tag does not work otherwise
  };

  # Current version does not have tests specified in setup.py.
  # To enable the tests during the build one needs to
  # 1) patch `i3ipc` source adding tests to `setup.py`
  # 2) make `pytest`, `Xvfb` and `i3` available to the test runner.
  #    (by adding the relevant packages to `nativeBuildInputs`)
  doCheck = false;

  propagatedBuildInputs = [ enum-compat ];

  meta = {
    homepage = "https://github.com/acrisci/i3ipc-python";
    description = "An improved library to control i3wm";
    maintainers = [ lib.maintainers.ilya-kolpakov ];
    license = lib.licenses.bsd3;
  };
}
