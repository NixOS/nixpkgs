{ lib
, buildPythonPackage
, fetchPypi
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
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f6f0fb83c51ffa3a150fa41b5ac118df9ea4a87c2c06dff4ebf9adbe7b52b36";
  };

  disabled = !isPy3k;
  propagatedBuildInputs = [ docutils requests requests_download pytoml ]
    ++ lib.optional (pythonOlder "3.6") zipfile36;

  checkInputs = [ pytest testpath responses ];

  # Disable test that needs some ini file.
  # Disable test that wants hg
  checkPhase = ''
    HOME=$(mktemp -d) pytest -k "not test_invalid_classifier and not test_build_sdist"
  '';

  meta = {
    description = "A simple packaging tool for simple packages";
    homepage = https://github.com/takluyver/flit;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.fridh ];
  };
}
