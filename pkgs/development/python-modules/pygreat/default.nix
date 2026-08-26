{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyusb,
}:

buildPythonPackage rec {
  pname = "pygreat";
  version = "2026.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "libgreat";
    tag = "v${version}";
    hash = "sha256-m+s2TAJK7UhKWbuSd5ec1O40WeMXxJyTD9yqPOr0LEM=";
  };

  sourceRoot = "${src.name}/host";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [ pyusb ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pygreat" ];

  meta = {
    description = "Python library for talking with libGreat devices";
    homepage = "https://github.com/greatscottgadgets/libgreat/";
    changelog = "https://github.com/greatscottgadgets/libgreat/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ carlossless ];
  };
}
