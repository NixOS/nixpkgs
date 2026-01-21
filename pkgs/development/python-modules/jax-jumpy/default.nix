{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jumpy";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "jumpy";
    rev = version;
    hash = "sha256-tPQ/v2AVnAEC+08BVAvvgJ8Pj89nXZSn2tQ6nxXuSfA=";
  };

  pyproject = true;

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "jumpy" ];

  meta = {
    description = "Jumpy is a common backend for NumPy and optionally JAX";
    homepage = "https://github.com/Farama-Foundation/Jumpy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
