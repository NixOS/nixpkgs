{ lib, isPy27, fetchFromGitHub, buildPythonPackage, fetchpatch, flake8, six }:

buildPythonPackage rec {
  pname = "flake8-future-import";
  version = "0.4.6";

  # PyPI tarball doesn't include the test suite
  src = fetchFromGitHub {
    owner = "xZise";
    repo = "flake8-future-import";
    rev = version;
    sha256 = "00q8n15xdnvqj454arn7xxksyrzh0dw996kjyy7g9rdk0rf8x82z";
  };

  propagatedBuildInputs = [ flake8 six ];

  # Upstream disables this test case naturally on python 3, but it also fails
  # inside NixPkgs for python 2. Since it's going to be deleted, we just skip it
  # on py2 as well.
  patches = lib.optionals isPy27 [ ./skip-test.patch ];

  meta = with lib; {
    description = "A flake8 extension to check for the imported __future__ modules to make it easier to have a consistent code base";
    homepage = "https://github.com/xZise/flake8-future-import";
    license = licenses.mit;
  };
}
