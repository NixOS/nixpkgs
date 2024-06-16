# Introduced as a dependency for python3Packages.nerfstudio

{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, numpy
}:

buildPythonPackage rec {
  pname = "newrawpy";
  version = "1.0.0b0";
  pyproject = true;

  # Using PyPi because there are no git tags on GitHub
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/oCrFqLMX3YNEsEwYFuUhGdGwXddJLQNg55PumVc5V8=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [ "newrawpy" ];

  meta = with lib; {
    description = "RAW image processing for Python, a wrapper for libraw";
    homepage = "https://pypi.org/project/newrawpy/";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [ ];
  };
}
