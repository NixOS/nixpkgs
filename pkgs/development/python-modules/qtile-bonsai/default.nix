{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cairocffi,
  cffi,
  psutil,
  xcffib,
  uv-build,
  pyside6,
  pyvirtualdisplay,
  pytestCheckHook,
  qtile,
}:
buildPythonPackage rec {
  pname = "qtile-bonsai";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aravinda0";
    repo = "qtile-bonsai";
    tag = "v${version}";
    hash = "sha256-JCElI4Ymr99p9dj++N9lyTFNmikntBwwImYREXFsUo0=";
  };

  build-system = [
    uv-build
  ];

  dependencies = [
    psutil
  ];

  nativeCheckInputs = [
    pyside6
    pyvirtualdisplay
    (cairocffi.override { withXcffib = true; })
    cffi
    xcffib
    qtile
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'uv_build>=0.8.13,<0.9.0' 'uv_build'
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTestPaths = [
    # Needs a running DBUS
    "tests/integration/test_layout.py"
    "tests/integration/test_widget.py"
  ];

  pythonImportsCheck = [ "qtile_bonsai" ];

  meta = {
    changelog = "https://github.com/aravinda0/qtile-bonsai/releases/tag/${version}";
    homepage = "https://github.com/aravinda0/qtile-bonsai";
    description = "Flexible layout for the qtile tiling window manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gurjaka
      sigmanificient
    ];
  };
}
