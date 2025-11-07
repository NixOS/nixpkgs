{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  versioningit,

  # dependencies
  autobahn,
  cffi,
  packaging,
  pandas,
  qcodes,
  python-dotenv,

  # tests
  pytest-mock,
  pytestCheckHook,
  pyvisa-sim,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "qcodes-contrib-drivers";
  version = "0.23.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "QCoDeS";
    repo = "Qcodes_contrib_drivers";
    tag = "v${version}";
    hash = "sha256-m2idBaQl2OVhrY5hcLTeXY6BycGf0ufa/ySgxaU2L/4=";
  };

  build-system = [
    setuptools
    versioningit
  ];

  dependencies = [
    autobahn
    cffi
    packaging
    pandas
    qcodes
    python-dotenv
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    pyvisa-sim
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "qcodes_contrib_drivers" ];

  disabledTests =
    lib.optionals stdenv.hostPlatform.isDarwin [
      # At index 13 diff: 'sour6:volt 0.29000000000000004' != 'sour6:volt 0.29'
      "test_stability_diagram_external"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # AssertionError: assert ['outp:trig4:...9999996', ...] == ['outp:trig4:...t 0.266', ...]
      "test_stability_diagram_external"
    ];

  meta = {
    description = "User contributed drivers for QCoDeS";
    homepage = "https://github.com/QCoDeS/Qcodes_contrib_drivers";
    changelog = "https://github.com/QCoDeS/Qcodes_contrib_drivers/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ evilmav ];
  };
}
