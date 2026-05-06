{
  fetchPypi,
  lib,
  python3Packages,
}:
python3Packages.buildPythonPackage rec {
  pname = "ez_setup";
  version = "0.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MDxbF9VS0eP7BQXYBUn4V59VfhPY3JDl7O88B9f1hkI=";
  };

  build-system = with python3Packages; [
    distutils
    setuptools
  ];

  pythonImportsCheck = [
    "ez_setup"
  ];

  meta = {
    description = "Ez_setup.py and distribute_setup.py";
    homepage = "https://github.com/ActiveState/ez_setup";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xelden ];
  };
}

