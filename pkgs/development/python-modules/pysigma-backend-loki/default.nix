{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysigma-backend-loki";
  version = "0.12.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "pySigma-backend-loki";
    tag = "v${version}";
    hash = "sha256-tsAtD98vWU8mB+Y3ePp2S54dSDu5R7DIDYDin+JJgSg=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pysigma ];

  pythonRelaxDeps = [ "pysigma" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sigma.backends.loki" ];

  meta = with lib; {
    description = "Library to support the loki backend for pySigma";
    homepage = "https://github.com/grafana/pySigma-backend-loki";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ peterromfeldhk ];
  };
}
