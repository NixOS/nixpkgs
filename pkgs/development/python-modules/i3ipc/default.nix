{ pkgs, buildPythonPackage, enum-compat }:

let
  version = "1.3.0";
  sha256 = "1rw9mq18np6bf8xp8vvc21bi5q8xjmj8dck2vsa1hy8bk434259m";

in buildPythonPackage rec {
  name = "i3ipc-${version}";
  inherit version;

  src = pkgs.fetchFromGitHub {
    owner = "acrisci";
    repo = "i3ipc-python";
    rev = "refs/tags/v${version}";
    inherit sha256;
    fetchSubmodules = true; # because a tag is used
  };

  doCheck = false;

  propagatedBuildInputs = [ enum-compat ];

  meta = {
    homepage = "https://github.com/acrisci/i3ipc-python";
    description = "An improved library to control i3wm";
    license = pkgs.lib.licenses.bsd3;
  };
}
