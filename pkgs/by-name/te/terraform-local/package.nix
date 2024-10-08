{
  lib,
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonApplication rec {
  pname = "terraform_local";
  version = "0.20.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Lxx/gtjLufFZWzcvOiiSUUptM7JtFnigBN7DG+lhQxg=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    python-hcl2
    packaging
    localstack-client
  ];

  # Can’t run `pytestCheckHook` because the tests are integration tests and expect localstack to be present, which in turn expects docker to be running.
  doCheck = false;

  # There is no `pythonImportsCheck` because the package only outputs a binary: tflocal
  dontUsePythonImportsCheck = true;

  meta = with lib; {
    description = "Terraform CLI wrapper to deploy your Terraform applications directly to LocalStack";
    homepage = "https://github.com/localstack/terraform-local";
    license = licenses.asl20;
    maintainers = with maintainers; [ shivaraj-bh ];
  };
}
