{ lib, fetchFromGitHub, buildPythonPackage, python, flake8, six,
  fetchurl }:

buildPythonPackage rec {
  pname = "flake8-future-import";
  version = "0.4.5";

  # PyPI tarball doesn't include the test suite
  src = fetchFromGitHub {
    owner = "xZise";
    repo = "flake8-future-import";
    rev = version;
    sha256 = "00fpxa6g8cabybnciwnpsbg60zhgydc966jgwyyggw1pcg0frdqr";
  };

  propagatedBuildInputs = [ flake8 six ];

  meta = {
    homepage = https://github.com/xZise/flake8-future-import;
    description = "A flake8 extension to check for the imported __future__ modules to make it easier to have a consistent code base";
    license = lib.licenses.mit;
  };
}
