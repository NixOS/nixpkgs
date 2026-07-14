{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  logistro,
  simplejson,
}:

buildPythonPackage (finalAttrs: {
  pname = "choreographer";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "choreographer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WjAE3UlUCiXK5DxwmZvehQQaoJRkgEE8rNJQdAyOM4Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools-git-versioning"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${finalAttrs.version}"'
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    logistro
    simplejson
  ];

  pythonImportsCheck = [ "choreographer" ];

  # Tests require running chrome
  doCheck = false;

  meta = {
    description = "Devtools Protocol implementation for chrome";
    homepage = "https://github.com/plotly/choreographer";
    changelog = "https://github.com/plotly/choreographer/blob/${finalAttrs.src.tag}/CHANGELOG.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
