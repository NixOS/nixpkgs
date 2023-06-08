{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "knx-frontend";
  version = "2023.5.31.141540";
  format = "pyproject";

  # TODO: source build, uses yarn.lock
  src = fetchPypi {
    pname = "knx_frontend";
    inherit version;
    hash = "sha256-j0p3PUYnKsyuDaN+nMrIHhxLYhNXVkZQkgsp//ZTsXE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "knx_frontend"
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/XKNX/knx-frontend/releases/tag/${version}";
    description = "Home Assistant Panel for managing the KNX integration";
    homepage = "https://github.com/XKNX/knx-frontend";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
