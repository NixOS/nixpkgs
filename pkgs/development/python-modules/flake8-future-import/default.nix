{ lib, fetchFromGitHub, buildPythonPackage, fetchpatch, flake8, six }:

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

  patches = [
    # Add Python 3.7 support. Remove with the next release
    (fetchpatch {
      url = https://github.com/xZise/flake8-future-import/commit/cace194a44d3b95c9c1ed96640bae49183acca04.patch;
      sha256 = "17pkqnh035j5s5c53afs8bk49bq7lnmdwqp5k7izx7sw80z73p9r";
    })
  ];

  propagatedBuildInputs = [ flake8 six ];

  meta = {
    homepage = https://github.com/xZise/flake8-future-import;
    description = "A flake8 extension to check for the imported __future__ modules to make it easier to have a consistent code base";
    license = lib.licenses.mit;
  };
}
