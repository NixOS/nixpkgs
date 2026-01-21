{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pybind11,
  re2,
}:

buildPythonPackage rec {
  pname = "google-re2";
  version = "1.1.20251105";
  pyproject = true;

  src = fetchPypi {
    pname = "google_re2";
    inherit version;
    hash = "sha256-HbFKKS7oMDuR6R58N+BawX08Rn8pQWx5rHCni+PmW9o=";
  };

  build-system = [ setuptools ];

  buildInputs = [ re2 ];

  dependencies = [ pybind11 ];

  doCheck = false; # no tests in sdist

  pythonImportsCheck = [ "re2" ];

  meta = {
    description = "RE2 Python bindings";
    homepage = "https://github.com/google/re2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ alexbakker ];
  };
}
