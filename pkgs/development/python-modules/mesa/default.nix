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
  version = "2.2.4";
  format = "setuptools";

  # According to their docs, this library is for Python 3+.
  disabled = isPy27;

  src = fetchPypi {
    pname = "mesa";
    inherit version;
    hash = "sha256-5og3ACS2r36BEGWfqtw6WG6yJwNF5p3M9K25sSmHosM=";
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
