{ lib
, buildPythonPackage
, fetchFromGitHub
, docutils
, requests
, pytest
, testpath
, responses
, flit-core
, tomli
, tomli-w
}:

# Flit is actually an application to build universal wheels.
# It requires Python 3 and should eventually be moved outside of
# python-packages.nix. When it will be used to build wheels,
# care should be taken that there is no mingling of PYTHONPATH.

buildPythonPackage rec {
  pname = "flit";
  version = "3.6.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "takluyver";
    repo = "flit";
    rev = version;
    sha256 = "sha256-D3q/1g6njrrmizooGmzNd9g2nKs00dMGj9jrrv3Y6HQ=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    docutils
    requests
    flit-core
    tomli
    tomli-w
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
