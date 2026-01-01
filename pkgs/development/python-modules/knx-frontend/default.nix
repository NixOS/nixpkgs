{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "knx-frontend";
<<<<<<< HEAD
  version = "2025.12.25.200238";
=======
  version = "2025.10.31.195356";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  # TODO: source build, uses yarn.lock
  src = fetchPypi {
    pname = "knx_frontend";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-xE54xdF/+6Un8VmdqBoqYopngIafEwU5IdtkOyxbuFI=";
=======
    hash = "sha256-m490gincBGm5qN1ndVfw8HZYnIh9RNLHQkW6w4duTTE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "knx_frontend" ];

  # no tests
  doCheck = false;

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/XKNX/knx-frontend/releases/tag/${version}";
    description = "Home Assistant Panel for managing the KNX integration";
    homepage = "https://github.com/XKNX/knx-frontend";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
=======
  meta = with lib; {
    changelog = "https://github.com/XKNX/knx-frontend/releases/tag/${version}";
    description = "Home Assistant Panel for managing the KNX integration";
    homepage = "https://github.com/XKNX/knx-frontend";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
