{ lib
, buildPythonPackage
, fetchPypi

, setuptools-scm
, hatchling
, hatch-vcs
, numpy
, numba
, cffi
, jax
, jaxlib
} :

buildPythonPackage rec {
  pname = "numba4jax";
  version = "0.0.14";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oWkRw9PRrHLNbZ/dADwoW0uG/jZcoHK4GHwijFARYw8=";
  };

  build-system = [ setuptools-scm ];
  nativeBuildInputs = [ hatchling hatch-vcs ];
  propagatedBuildInputs = [ jax jaxlib numpy numba cffi ];

  pythonImportsCheck = [ "numba4jax" ];

  meta = with lib; {
    homepage = "https://github.com/PhilipVinc/numba4jax";
    description = "use numba-jitted functions from within jax with no overhead";
    license = licenses.mit;
    maintainers = with maintainers; [ ulysseszhan ];
  };

}
