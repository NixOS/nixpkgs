{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  future,
  pyusb,
}:

buildPythonPackage rec {
  pname = "pygreat";
  version = "2024.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "libgreat";
    tag = "v${version}";
    hash = "sha256-2PFeCG7m8qiK3eBX2838P6ZsLoQxcJBG+/TppUMT6dE=";
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
    "backports.functools_lru_cache"
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
    changelog = "https://github.com/greatscottgadgets/libgreat/releases/tag/${src.tag}";
    description = "Python library for talking with libGreat devices";
    homepage = "https://github.com/greatscottgadgets/libgreat/";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ carlossless ];
  };
}
