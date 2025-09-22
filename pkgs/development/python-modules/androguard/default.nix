{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  apkinspector,
  networkx,
  pygments,
  lxml,
  colorama,
  cryptography,
  dataset,
  frida-python,
  loguru,
  matplotlib,
  asn1crypto,
  click,
  mutf8,
  pyyaml,
  pydot,
  ipython,
  oscrypto,
  pyqt5,
  pytestCheckHook,
  python-magic,
  qt5,
  # This is usually used as a library, and it'd be a shame to force the GUI
  # libraries to the closure if GUI is not desired.
  withGui ? false,
  # Deprecated in 24.11.
  doCheck ? true,
}:

assert lib.warnIf (!doCheck) "python3Packages.androguard: doCheck is deprecated" true;

buildPythonPackage rec {
  pname = "androguard";
  version = "4.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "androguard";
    owner = "androguard";
    tag = "v${version}";
    sha256 = "sha256-qz6x7UgYXal1DbQGzi4iKnSGEn873rKibKme/pF7tLk=";
  };

  build-system = [
    poetry-core
  ];

  nativeBuildInputs = lib.optionals withGui [ qt5.wrapQtAppsHook ];

  dependencies = [
    apkinspector
    asn1crypto
    click
    colorama
    cryptography
    dataset
    frida-python
    ipython
    loguru
    lxml
    matplotlib
    mutf8
    networkx
    oscrypto
    pydot
    pygments
    pyyaml
  ]
  ++ networkx.optional-dependencies.default
  ++ networkx.optional-dependencies.extra
  ++ lib.optionals withGui [
    pyqt5
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyqt5
    python-magic
  ];

  # If it won't be verbose, you'll see nothing going on for a long time.
  pytestFlags = [ "--verbose" ];

  preFixup = lib.optionalString withGui ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = {
    description = "Tool and Python library to interact with Android Files";
    homepage = "https://github.com/androguard/androguard";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pmiddend ];
  };
}
