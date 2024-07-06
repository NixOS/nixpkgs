{ lib
, buildPythonPackage
, fetchPypi

, setuptools-scm
, hatchling
, hatch-vcs
, jax
, jaxlib
, numpy
, scipy
, tqdm
, numba
, igraph
, flax
, orjson
, optax
, numba4jax
, beartype
, rich
} :

buildPythonPackage rec {
  pname = "netket";
  version = "3.11.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D1dWvKWbJk9b4QthhHiKUZ/qBNy8V7ofXktkns2o5X4=";
  };

  build-system = [ setuptools-scm ];
  nativeBuildInputs = [ hatchling hatch-vcs ];
  propagatedBuildInputs = [
    jax
    jaxlib
    numpy
    scipy
    tqdm
    numba
    igraph
    flax
    orjson
    optax
    numba4jax
    beartype
    rich
  ];

  pythonImportsCheck = [ "netket" ];

  meta = with lib; {
    homepage = "https://www.netket.org/";
    changelog = "https://github.com/netket/netket/blob/master/CHANGELOG.md";
    description = "The Machine-Learning toolbox for Quantum Physics";
    license = licenses.asl20;
    maintainers = with maintainers; [ ulysseszhan ];
  };

}
