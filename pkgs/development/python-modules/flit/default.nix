{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, isPy3k
, docutils
, requests
, requests_download
, zipfile36
, pythonOlder
, pytest
, testpath
, responses
, flit-core
}:

# Flit is actually an application to build universal wheels.
# It requires Python 3 and should eventually be moved outside of
# python-packages.nix. When it will be used to build wheels,
# care should be taken that there is no mingling of PYTHONPATH.

buildPythonPackage rec {
  pname = "flit";
  version = "3.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "takluyver";
    repo = "flit";
    rev = version;
    sha256 = "sha256-zN+/oAyXBo6Ho7n/xhOQ2mjtPGKA1anCvl3sVf7t+Do=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    docutils
    requests
    requests_download
    flit-core
  ] ++ lib.optionals (pythonOlder "3.6") [
    zipfile36
  ];

  checkInputs = [ pytest testpath responses ];

  # Disable test that needs some ini file.
  # Disable test that wants hg
  checkPhase = ''
    HOME=$(mktemp -d) pytest -k "not test_invalid_classifier and not test_build_sdist"
  '';

  meta = with lib; {
    description = "A simple packaging tool for simple packages";
    homepage = "https://github.com/takluyver/flit";
    license = licenses.bsd3;
    maintainers = [ maintainers.fridh ];
  };
}
