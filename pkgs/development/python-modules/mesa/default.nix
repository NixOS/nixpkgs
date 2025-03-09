{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  cookiecutter,
  networkx,
  pandas,
  tornado,
  tqdm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mesa";
  version = "3.1.3";
  format = "setuptools";

  # According to their docs, this library is for Python 3+.
  disabled = isPy27;

  src = fetchPypi {
    pname = "mesa";
    inherit version;
    hash = "sha256-sM9k3fkk0RMU3OPF8JISOspw+KoR7PXHPK7IMIGAS78=";
  };

  propagatedBuildInputs = [
    cookiecutter
    networkx
    pandas
    tornado
    tqdm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    "test_examples"
    "test_run"
    "test_scaffold_creates_project_dir"
  ];

  meta = with lib; {
    homepage = "https://github.com/projectmesa/mesa";
    description = "Agent-based modeling (or ABM) framework in Python";
    license = licenses.asl20;
    maintainers = [ maintainers.dpaetzel ];
    broken = true; # missing dependencies
  };
}
