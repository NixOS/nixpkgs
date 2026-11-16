{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  click,
  typing-extensions,
  setuptools,
  pydantic,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "clickdc";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kamilcuk";
    repo = "clickdc";
    tag = finalAttrs.version;
    hash = "sha256-pOMArEWmoDTWZWSK7IemuqP+lSqOZgzzP6xKtmpOS90=";
  };

  patches = [
    (fetchpatch {
      name = "clickdc-fix-click-8.2-tests.patch";
      url = "https://github.com/Kamilcuk/clickdc/commit/906faf8dfc48ff4bde9b3e5eec19620fc5100927.patch";
      hash = "sha256-S6Wl/yotKD3RvqSp0Z3vNls7XnxgF42GBjeCrMWtIMQ=";
    })
    (fetchpatch {
      name = "clickdc-modernize-tests.patch";
      url = "https://github.com/Kamilcuk/clickdc/commit/83e79a4522b9070fd4bdad2f521f8f502380a7a9.patch";
      hash = "sha256-d2ZxFa2I5StDnJyDrgTHTIasyXcprBF6lcf5s7eGRRE=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2",' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${finalAttrs.version}"'
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    click
    typing-extensions
  ];

  nativeCheckInputs = [
    pydantic
    pytestCheckHook
  ];

  pythonImportsCheck = [ "clickdc" ];

  meta = {
    description = "Define click command line options from a python dataclass";
    homepage = "https://github.com/Kamilcuk/clickdc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kyehn ];
  };
})
