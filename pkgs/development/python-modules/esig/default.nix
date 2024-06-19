{
  lib,
  buildPythonPackage,
  fetchPypi,
  cmake,
  ninja,
  oldest-supported-numpy,
  scikit-build,
  setuptools,
  numpy,
  iisignature,
  boost,
}:

buildPythonPackage rec {
  pname = "esig";
  version = "0.9.8.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BGZaJSrpNSwZMHBYFDmDVPZOtgam/EVyh5Y5FAB8e1o=";
  };

  buildInputs = [ boost ];

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    ninja
    oldest-supported-numpy
    scikit-build
    setuptools
  ];

  propagatedBuildInputs = [ numpy ];

  passthru.optional-dependencies = {
    iisignature = [ iisignature ];
  };

  # PyPI tarball has no tests
  doCheck = false;

  pythonImportsCheck = [ "esig" ];

  meta = with lib; {
    description = "This package provides \"rough path\" tools for analysing vector time series";
    homepage = "https://github.com/datasig-ac-uk/esig";
    changelog = "https://github.com/datasig-ac-uk/esig/blob/release/CHANGELOG";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
