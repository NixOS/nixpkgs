{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:
let
  version = "4.6.1";
in
buildPythonPackage {
  pname = "pypresence";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qwertyquerty";
    repo = "pypresence";
    tag = "v${version}";
    hash = "sha256-VvVHJ3S+Yusq4cK4KyDQlnL3VwAyrZqNKYzEgJPU8Vk=";
  };

  build-system = [ setuptools ];

  doCheck = false; # tests require internet connection
  pythonImportsCheck = [ "pypresence" ];

  meta = {
    homepage = "https://qwertyquerty.github.io/pypresence/html/index.html";
    description = "Discord RPC client written in Python";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
