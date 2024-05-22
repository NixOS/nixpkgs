{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pbr,
  httpx,
  pillow,
  pycryptodome,
  pyjwt,
  pytest-asyncio,
  pytestCheckHook,
  python,
  respx,
  setuptools,
  time-machine,
  tzdata,
}:

buildPythonPackage rec {
  pname = "bimmer-connected";
  version = "0.15.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bimmerconnected";
    repo = "bimmer_connected";
    rev = "refs/tags/${version}";
    hash = "sha256-UCzPD+3v74eB32q0/blsyHAsN0yNskGky5nrBKzFFaE=";
  };

  build-system = [
    pbr
    setuptools
  ];

  PBR_VERSION = version;

  dependencies = [
    httpx
    pycryptodome
    pyjwt
  ];

  passthru.optional-dependencies = {
    china = [ pillow ];
  };

  postInstall = ''
    cp -R bimmer_connected/tests/responses $out/${python.sitePackages}/bimmer_connected/tests/
  '';

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    respx
    time-machine
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  disabledTests = [
    # presumably regressed in pytest-asyncio 0.23.0
    "test_get_remote_position_too_old"
  ];

  preCheck = ''
    export TZDIR=${tzdata}/${python.sitePackages}/tzdata/zoneinfo
  '';

  pythonImportsCheck = [ "bimmer_connected" ];

  meta = with lib; {
    changelog = "https://github.com/bimmerconnected/bimmer_connected/releases/tag/${version}";
    description = "Library to read data from the BMW Connected Drive portal";
    mainProgram = "bimmerconnected";
    homepage = "https://github.com/bimmerconnected/bimmer_connected";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
