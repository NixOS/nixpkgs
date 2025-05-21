{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  versioningit,
  cffi,
  qcodes,
  packaging,
  pandas,
  pytestCheckHook,
  pytest-mock,
  pyvisa-sim,
  stdenv,
}:

buildPythonPackage rec {
  pname = "qcodes-contrib-drivers";
  version = "0.22.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "QCoDeS";
    repo = "Qcodes_contrib_drivers";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-/W5oC5iqYifMR3/s7aSQ2yTJNmkemkc0KVxIU0Es3zY=";
  };

  build-system = [
    setuptools
    versioningit
  ];

  dependencies = [
    cffi
    qcodes
    packaging
    pandas
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pyvisa-sim
  ];

  pythonImportsCheck = [ "qcodes_contrib_drivers" ];

  disabledTests =
    lib.optionals (stdenv.isDarwin) [
      # At index 13 diff: 'sour6:volt 0.29000000000000004' != 'sour6:volt 0.29'
      "test_stability_diagram_external"
    ]
    ++ lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
      # AssertionError: assert ['outp:trig4:...9999996', ...] == ['outp:trig4:...t 0.266', ...]
      "test_stability_diagram_external"
    ];

  postInstall = ''
    export HOME="$TMPDIR"
  '';

  meta = {
    description = "User contributed drivers for QCoDeS";
    homepage = "https://github.com/QCoDeS/Qcodes_contrib_drivers";
    changelog = "https://github.com/QCoDeS/Qcodes_contrib_drivers/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ evilmav ];
  };
}
