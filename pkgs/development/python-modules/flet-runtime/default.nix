{
  lib,
  buildPythonPackage,
  flet-client-flutter,
  poetry-core,
  pythonRelaxDepsHook,
  flet-core,
  httpx,
  oauthlib,
}:

buildPythonPackage rec {
  pname = "flet-runtime";
  inherit (flet-client-flutter) version src;

  pyproject = true;

  sourceRoot = "${src.name}/sdk/python/packages/flet-runtime";

  postPatch = ''
    substitute ${./_setup_runtime.py} src/flet_runtime/_setup_runtime.py \
      --replace @flet-client-flutter@ ${flet-client-flutter}

    echo -e "import flet_runtime._setup_runtime\n$(cat src/flet_runtime/__init__.py)" > src/flet_runtime/__init__.py
  '';

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [ "httpx" ];

  propagatedBuildInputs = [
    flet-core
    httpx
    oauthlib
  ];

  pythonImportsCheck = [ "flet_runtime" ];

  meta = {
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${version}";
    description = "A base package for Flet desktop and Flet mobile";
    homepage = "https://flet.dev/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lucasew ];
  };
}
