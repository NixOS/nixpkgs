{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  future,
  networkx,
  pygments,
  lxml,
  colorama,
  matplotlib,
  asn1crypto,
  click,
  pydot,
  ipython,
  pyqt5,
  pyperclip,
  pytestCheckHook,
  mock,
  python-magic,
  codecov,
  coverage,
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
  version = "3.4.0a1";
  pyproject = true;

  src = fetchFromGitHub {
    repo = pname;
    owner = pname;
    rev = "v${version}";
    sha256 = "1aparxiq11y0hbvkayp92w684nyxyyx7mi0n1x6x51g5z6c58vmy";
  };

  patches = [
    ./drop-removed-networkx-formats.patch
    ./fix-tests.patch
  ];

  build-system = [ setuptools ];

  nativeBuildInputs = lib.optionals withGui [ qt5.wrapQtAppsHook ];

  dependencies =
    [
      asn1crypto
      click
      colorama
      future
      ipython
      lxml
      matplotlib
      networkx
      pydot
      pygments
    ]
    ++ networkx.optional-dependencies.default
    ++ networkx.optional-dependencies.extra
    ++ lib.optionals withGui [
      pyqt5
      pyperclip
    ];

  nativeCheckInputs = [
    pytestCheckHook
    codecov
    coverage
    mock
    pyperclip
    pyqt5
    python-magic
  ];

  # If it won't be verbose, you'll see nothing going on for a long time.
  pytestFlagsArray = [ "--verbose" ];

  preFixup = lib.optionalString withGui ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Tool and Python library to interact with Android Files";
    homepage = "https://github.com/androguard/androguard";
    license = licenses.asl20;
    maintainers = with maintainers; [ pmiddend ];
  };
}
