{ lib, fetchFromGitHub, buildPythonPackage, python, flake8, six }:

buildPythonPackage rec {
  pname = "flake8-future-import";
  name = "${pname}-${version}";
  version = "0.4.3";
  # PyPI tarball doesn't include the test suite
  src = fetchFromGitHub {
    owner = "xZise";
    repo = "flake8-future-import";
    rev = version;
    sha256 = "0622bdcfa588m7g8igag6hf4rhjdwh74yfnrjwlxw4vlqhg344k4";
  };
  propagatedBuildInputs = [ flake8 six ];
  meta = {
    homepage = https://github.com/xZise/flake8-future-import;
    description = "A flake8 extension to check for the imported __future__ modules to make it easier to have a consistent code base";
    license = lib.licenses.mit;
  };
}
