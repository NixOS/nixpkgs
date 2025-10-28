{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynamecheap";
  version = "0.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bemmu";
    repo = "PyNamecheap";
    tag = "v${version}";
    hash = "sha256-J2WYWtZGtZiox4q9tdkLyU1nix9Jn64K0+1mw7xoLLw=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Tests require access to api.sandbox.namecheap.com
  doCheck = false;

  pythonImportsCheck = [ "namecheap" ];

  meta = with lib; {
    description = "Namecheap API client in Python";
    homepage = "https://github.com/Bemmu/PyNamecheap";
    changelog = "https://github.com/Bemmu/PyNamecheap/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
