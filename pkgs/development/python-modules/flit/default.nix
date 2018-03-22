{ lib
, buildPythonPackage
, fetchPypi
, fetchurl
, isPy3k
, docutils
, requests
, requests_download
, zipfile36
, pythonOlder
, pytest
, testpath
, responses
, pytoml
}:

# Flit is actually an application to build universal wheels.
# It requires Python 3 and should eventually be moved outside of
# python-packages.nix. When it will be used to build wheels,
# care should be taken that there is no mingling of PYTHONPATH.

buildPythonPackage rec {
  pname = "flit";
  version = "0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f558351bf4bb82b872d3bdbea7055cbb2e33ed2bdf809284bf927d4c78bf0ee";
  };

  disabled = !isPy3k;
  propagatedBuildInputs = [ docutils requests requests_download pytoml ] ++ lib.optional (pythonOlder "3.6") zipfile36;

  checkInputs = [ pytest testpath responses ];

  # Disable test that needs some ini file.
  # Disable test that wants hg
  checkPhase = ''
    py.test -k "not test_invalid_classifier and not test_build_sdist"
  '';

  meta = {
    description = "A simple packaging tool for simple packages";
    homepage = https://github.com/takluyver/flit;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.fridh ];
  };
}
