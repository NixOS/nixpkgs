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
  version = "0.0.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4fr2oFZvT7lBq/iCG5yFS3OY6wigyBV5J/i0cXo5NEY=";
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
