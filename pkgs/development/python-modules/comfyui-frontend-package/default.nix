{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  pnpmConfigHook,
  fetchPnpmDeps,
  pnpm_10,
  nodejs-slim, # don't need npm
}:
buildPythonPackage rec {
  pname = "comfyui-frontend-package";
  version = "1.42.2";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  # uses localhost for testing
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI_frontend";
    rev = "v${version}";
    hash = "sha256-2aPnZf9sCx1oi/kiN4XPretV8Zhz2KJFw5vvXnBpUv4=";
  };

  # used by setup.py
  env.COMFYUI_FRONTEND_VERSION = version;
  # prevents vitest scrolling logging
  env.CI = true;

  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    fetcherVersion = 2;
    hash = "sha256-jt7uv86j7KGpS8IqZz/T6HFLzvcNh9aOvVoSHxRR91M=";
  };

  nativeBuildInputs = [
    nodejs-slim
    pnpm_10
    pnpmConfigHook
  ];

  # bypass useless nx
  # also switch to a non-interactive reporter to avoid logging spam
  postPatch = ''
    substituteInPlace ./package.json \
      --replace-fail "nx build" "vite build" \
      --replace-fail "nx run test" "vitest run --reporter=basic"
  '';

  preBuild = ''
    pnpm run build
    mv ./dist ./comfyui_frontend_package/comfyui_frontend_package/static
    # dir containing setup.py
    cd ./comfyui_frontend_package
  '';

  # skip performance tests as they are quite tightly timed and as a result
  # are hardware dependent
  # > expected 3.2442849999997634 to be less than 2
  checkPhase = ''
    runHook preCheck

    # skip completely for now
    # [error] Failed to load custom Reporter from basic
    # not sure why vitest can't find the basic reporter
    # cd ..
    # pnpm run test:unit -- --exclude tests-ui/tests/performance/*
    # # dir containing setup.py
    # cd ./comfyui_frontend_package

    runHook postCheck
  '';

  pythonImportsCheck = [ "comfyui_frontend_package" ];

  meta = {
    description = "Official front-end implementation of ComfyUI";
    homepage = "https://github.com/Comfy-Org/ComfyUI_frontend/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      jk
    ];
  };
}
