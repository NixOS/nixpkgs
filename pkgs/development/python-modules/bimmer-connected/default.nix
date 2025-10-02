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
  version = "0.17.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bimmerconnected";
    repo = "bimmer_connected";
    tag = version;
    hash = "sha256-XKKMOKvZO6CrAioflyhTWZrNJv1+5yqYPFL4Al8YPY8=";
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

  optional-dependencies = {
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
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests = [
    # presumably regressed in pytest-asyncio 0.23.0
    "test_get_remote_position_too_old"
  ];

  preCheck = ''
    export TZDIR=${tzdata}/${python.sitePackages}/tzdata/zoneinfo
    export PATH=$out/bin:$PATH
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
