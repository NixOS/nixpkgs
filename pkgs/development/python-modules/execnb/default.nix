{
  lib,
  buildPythonPackage,
  fastcore,
  fetchPypi,
  ipython,
  pythonOlder,
  setuptools,
  traitlets,
}:

buildPythonPackage rec {
  pname = "execnb";
<<<<<<< HEAD
  version = "0.1.16";
=======
  version = "0.1.15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-ZsnACca6Awv9DA9qce5NhWodjvxDBv6ajBU3DAZFAAw=";
=======
    hash = "sha256-KQYpCJBKXCjaVuRwWGTdltwlBBNprUqqII50vPXENXE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    fastcore
    ipython
    traitlets
  ];

  # no real tests
  doCheck = false;

  pythonImportsCheck = [ "execnb" ];

<<<<<<< HEAD
  meta = {
    description = "Execute a jupyter notebook, fast, without needing jupyter";
    homepage = "https://github.com/fastai/execnb";
    changelog = "https://github.com/fastai/execnb/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rxiao ];
=======
  meta = with lib; {
    description = "Execute a jupyter notebook, fast, without needing jupyter";
    homepage = "https://github.com/fastai/execnb";
    changelog = "https://github.com/fastai/execnb/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ rxiao ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "exec_nb";
  };
}
