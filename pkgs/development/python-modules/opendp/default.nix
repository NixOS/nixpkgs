{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-rust,
  deprecated,
}:

buildPythonPackage rec {
  pname = "opendp";
  version = "0.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opendp";
    repo = "opendp";
    tag = "v${version}";
    hash = "sha256-k8VTOS0LOZ8ApwQ1XQkS7HJBTMRC6tssfE7RQwASZQQ=";
  };

  sourceRoot = "${src.name}/python";

  build-system = [ setuptools-rust ];

  dependencies = [ deprecated ];

  pythonImportsCheck = [ "opendp" ];
}
