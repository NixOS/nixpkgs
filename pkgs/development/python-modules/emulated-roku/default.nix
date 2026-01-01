{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "emulated-roku";
<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mindigmarton";
    repo = "emulated_roku";
<<<<<<< HEAD
    tag = version;
    hash = "sha256-lPe0mXtl1IQx//IydnmddpV11CpOi/MKq9TUOAKuoeU=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];
=======
    rev = version;
    hash = "sha256-7DbJl1e1ESWPCNuQX7m/ggXNDyPYZ5eNGwSz+jnxZj0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ aiohttp ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "emulated_roku" ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/martonperei/emulated_roku/releases/tag/${src.tag}";
    description = "Library to emulate a roku server to serve as a proxy for remotes such as Harmony";
    homepage = "https://github.com/mindigmarton/emulated_roku";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
=======
  meta = with lib; {
    description = "Library to emulate a roku server to serve as a proxy for remotes such as Harmony";
    homepage = "https://github.com/mindigmarton/emulated_roku";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
