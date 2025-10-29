{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  libavif,
  pillow,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pillow-avif-plugin";
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fdintino";
    repo = "pillow-avif-plugin";
    tag = "v${version}";
    hash = "sha256-gdDVgVNympxlTzj1VUqO+aU1/xWNjDm97a0biOTlKtA=";
  };

  build-system = [ setuptools ];

  buildInputs = [ libavif ];

  dependencies = [ pillow ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Pillow plugin that adds support for AVIF files";
    homepage = "https://github.com/fdintino/pillow-avif-plugin";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ratcornu ];
  };
}
