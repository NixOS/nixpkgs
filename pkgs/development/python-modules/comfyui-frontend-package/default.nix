{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  pnpm_10,
  nodejs,
}:
buildPythonPackage rec {
  pname = "comfyui-frontend-package";
  version = "1.29.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  # uses localhost for testing
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI_frontend";
    rev = "v${version}";
    hash = "sha256-YBi60kAtbNhAlnv/aEjtYaJI0LE/6HqeB9q6UWGTdSQ=";
  };

  # used by setup.py
  env.COMFYUI_FRONTEND_VERSION = version;
  # prevents vitest scrolling logging
  env.CI = true;

  pnpmDeps = pnpm_10.fetchDeps {
    inherit pname version src;
    fetcherVersion = 2;
    hash = "sha256-H9TiIxNdMfGP6PSClxNjkisb2G0f6AbxV1X9iAZAr1M=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
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

    cd ..
    pnpm run test:unit -- --exclude tests-ui/tests/performance/*
    # dir containing setup.py
    cd ./comfyui_frontend_package

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
