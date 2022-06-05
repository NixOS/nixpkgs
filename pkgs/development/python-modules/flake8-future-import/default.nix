{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, isPy38
, isPy39
, pythonAtLeast
, flake8
, six
, python
}:

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

  patches = lib.optionals (pythonAtLeast "3.10") [
    ./fix-annotations-version-11.patch
  ] ++ lib.optionals (isPy38 || isPy39) [
    ./fix-annotations-version-10.patch
  ] ++ lib.optionals isPy27 [
    # Upstream disables this test case naturally on python 3, but it also fails
    # inside NixPkgs for python 2. Since it's going to be deleted, we just skip it
    # on py2 as well.
    ./skip-test.patch
  ];

  propagatedBuildInputs = [ flake8 ];

  checkInputs = [ six ];

  checkPhase = ''
    ${python.interpreter} -m test_flake8_future_import
  '';

  meta = with lib; {
    description = "A flake8 extension to check for the imported __future__ modules to make it easier to have a consistent code base";
    homepage = "https://github.com/xZise/flake8-future-import";
    license = licenses.mit;
  };
}
