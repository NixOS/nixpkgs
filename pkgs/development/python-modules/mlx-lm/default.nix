{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  jinja2,
  mlx,
  numpy,
  protobuf,
  pyyaml,
  transformers,
}:

buildPythonPackage rec {
  pname = "mlx-lm";
  version = "0.26.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ml-explore";
    repo = "mlx-lm";
    rev = "v${version}";
    hash = "sha256-J69XIqsjQ4sQqhx+EkjKcVXVlQ4A4PGJvICSiCfoSOA=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    jinja2
    mlx
    numpy
    protobuf
    pyyaml
    transformers
  ];

  pythonImportsCheck = [
    "mlx_lm"
  ];

  meta = {
    description = "Run LLMs with MLX";
    homepage = "https://github.com/ml-explore/mlx-lm.git";
    license = lib.licenses.mit;
    platforms = [
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ ferrine ];
  };
}
