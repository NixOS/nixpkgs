{
  lib,
  buildPythonPackage,
  flet-client-flutter,

  # build-system
  poetry-core,
  pytestCheckHook,

  # propagates
  fastapi,
  httpx,
  oauthlib,
  packaging,
  qrcode,
  repath,
  cookiecutter,
  uvicorn,
  watchdog,
  websocket-client,
  websockets,
}:

buildPythonPackage rec {
  pname = "flet";
  inherit (flet-client-flutter) version src;
  pyproject = true;

  sourceRoot = "${src.name}/sdk/python/packages/flet";

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  makeWrapperArgs = [
    "--prefix"
    "PYTHONPATH"
    ":"
    "$PYTHONPATH"
  ];

  _flet_version = ''
    version = "${version}"
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
    fastapi
    uvicorn
    websocket-client
    watchdog
    oauthlib
    websockets
    httpx
    packaging
    repath
    qrcode
    cookiecutter
    fastapi
    uvicorn
  ];

  pythonImportsCheck = [ "flet" ];

  meta = {
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
