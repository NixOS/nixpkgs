{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  future,
  pyusb,
}:

buildPythonPackage rec {
  pname = "pygreat";
  version = "2024.0.3";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "libgreat";
    tag = "v${version}";
    hash = "sha256-dJqL85mx1zGYUpMxDa83hNRr7eUn5NNfWXullGFQK70=";
  };

  sourceRoot = "${src.name}/host";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [
    setuptools
  ];

  pythonRemoveDeps = [
    "backports.functools-lru-cache"
  ];

  dependencies = [
    future
    pyusb
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pygreat"
  ];

  meta = {
    changelog = "https://github.com/greatscottgadgets/libgreat/releases/tag/v${version}";
    description = "Python library for talking with libGreat devices";
    homepage = "https://github.com/greatscottgadgets/libgreat/";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ carlossless ];
  };
}
