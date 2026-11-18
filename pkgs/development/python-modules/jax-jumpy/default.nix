{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  jax,
  jaxlib,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "jax-jumpy";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "jumpy";
    tag = finalAttrs.version;
    hash = "sha256-tPQ/v2AVnAEC+08BVAvvgJ8Pj89nXZSn2tQ6nxXuSfA=";
  };

  pyproject = true;

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "jumpy" ];

  optional-dependencies = {
    jax = [
      jax
      jaxlib
    ];
  };

  meta = {
    description = "Jumpy is a common backend for NumPy and optionally JAX";
    homepage = "https://github.com/Farama-Foundation/Jumpy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
