{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  setuptools-scm,

  pillow,
  qrcode,
  python-barcode,
  six,
  appdirs,
  pyyaml,
  argcomplete,
  importlib-resources,

  pyusb,
  pyserial,
  pycups,

  jaconv,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
  scripttest,
  mock,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "python-escpos";
  version = "3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-escpos";
    repo = "python-escpos";
    tag = "v${version}";
    hash = "sha256-f7qA1+8PwnXS526jjULEoyn0ejnvsneuWDt863p4J2g=";
    fetchSubmodules = true;
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pillow
    qrcode
    python-barcode
    six
    appdirs
    pyyaml
    argcomplete
    importlib-resources
  ];

  optional-dependencies = {
    usb = [ pyusb ];
    serial = [ pyserial ];
    cups = [ pycups ];
    all = [
      pyusb
      pyserial
      pycups
    ];
  };

  preCheck = ''
    # force the tests to use the module in $out
    rm -r src

    # allow tests to find the cli executable
    export PATH="$out/bin:$PATH"
  '';

  nativeCheckInputs = [
    jaconv
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
    scripttest
    mock
    hypothesis
  ]
  ++ optional-dependencies.all;

  pythonImportsCheck = [ "escpos" ];

  meta = {
    changelog = "https://github.com/python-escpos/python-escpos/blob/${src.rev}/CHANGELOG.rst";
    description = "Python library to manipulate ESC/POS printers";
    homepage = "https://python-escpos.readthedocs.io/";
    license = lib.licenses.mit;
    mainProgram = "python-escpos";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
