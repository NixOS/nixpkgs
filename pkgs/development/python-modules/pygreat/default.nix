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
  version = "2024.0.2";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "libgreat";
    rev = "refs/tags/v${version}";
    hash = "sha256-yYp+2y4QIOykkrObWaXbZMMc2fsRn/+tGWqySA7V534=";
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
