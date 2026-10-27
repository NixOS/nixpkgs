{
  lib,
  buildPythonPackage,
  fetchPypi,
  babel,
  hatchling,
  hatch-jupyter-builder,
  ipykernel,
  ipython-genutils,
  jupyter-packaging,
  jupyter-server,
  nest-asyncio,
  notebook-shim,
  pytest-jupyter,
  pytest-tornasync,
  pytestCheckHook,
  yarnConfigHook,
  patch-package,
  fetchYarnDeps,
  nodejs,
}:

buildPythonPackage (finalAttrs: {
  pname = "nbclassic";
  version = "1.3.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Q0Iodj+M7nVDGM1t+kI3DbGRr2MNq6uOMLr8jBqj7uY=";
  };

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail 'npx patch-package' ${lib.getExe patch-package} \
      --replace-fail 'yarn install && ' ""
  '';

  preBuild = ''
    npm run postinstall
    npm run build
  '';

  build-system = [
    hatch-jupyter-builder
    hatchling
    babel
    jupyter-packaging
    jupyter-server
  ];

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
  ];

  dependencies = [
    ipykernel
    ipython-genutils
    nest-asyncio
    notebook-shim
  ];

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-Z932qAdGF3Jwj4kZWeCAr96Oe3M5T41sHNm+A3c44Ek=";
  };

  nativeCheckInputs = [
    pytest-jupyter
    pytest-tornasync
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nbclassic" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Jupyter lab environment notebook server extension";
    homepage = "https://github.com/jupyter/nbclassic";
    license = lib.licenses.bsd3;
  };
})
