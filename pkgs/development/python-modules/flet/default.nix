{
  lib,
  buildPythonPackage,
  flet-client-flutter,

  # build-system
  setuptools,

  # dependencies
  fastapi,
  httpx,
  msgpack,
  oauthlib,
  packaging,
  qrcode,
  repath,
  cookiecutter,
  uvicorn,
  watchdog,
  websocket-client,
  websockets,

  # tests
  numpy,
  pillow,
  pytest-asyncio,
  pytestCheckHook,
  scikit-image,
}:

buildPythonPackage rec {
  pname = "flet";
  inherit (flet-client-flutter) version src;
  pyproject = true;

  sourceRoot = "${src.name}/sdk/python/packages/flet";

  build-system = [ setuptools ];

  makeWrapperArgs = [
    "--prefix"
    "PYTHONPATH"
    ":"
    "$PYTHONPATH"
  ];

  _flet_version = ''
    flet_version = "${version}"
    def update_version():
      pass
  '';
  _flet_utils_pip = ''
    def install_flet_package(name: str):
      pass
  '';

  postPatch = ''
     # nerf out nagging about pip
    echo "$_flet_version" > src/flet/version.py
    echo "$_flet_utils_pip" >> src/flet/utils/pip.py
  '';

  dependencies = [
    cookiecutter
    fastapi
    httpx
    msgpack
    oauthlib
    packaging
    qrcode
    repath
    uvicorn
    watchdog
    websocket-client
    websockets
  ];

  nativeCheckInputs = [
    numpy
    pillow
    pytest-asyncio
    pytestCheckHook
    scikit-image
  ];

  pythonImportsCheck = [ "flet" ];

  meta = {
    broken = true;
    description = "Framework that enables you to easily build realtime web, mobile, and desktop apps in Python";
    homepage = "https://flet.dev/";
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      heyimnova
      lucasew
    ];
    mainProgram = "flet";
  };
}
