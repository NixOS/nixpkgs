{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "easing-functions";
  version = "1.0.4";
  pyproject = true;

  src = fetchPypi {
    pname = "easing_functions";
    inherit version;
    hash = "sha256-4Yx5MdRFuF8oxNFa0Kmke7ZdTi7vwNs4QESPriXj+d4=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "easing_functions" ];

  meta = with lib; {
    description = "A collection of the basic easing functions for python";
    homepage = "https://pypi.org/project/easing-functions/";
    # FIXME: nix-init did not found a license
    license = licenses.unfree;
    maintainers = [ ];
  };
}
