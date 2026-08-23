{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,

  # build-system
  setuptools,
  setuptools-lint,
  sphinx,

  # dependencies
  python-xlib,
  evdev,
  six,
  pyobjc-framework-ApplicationServices,
  pyobjc-framework-Quartz,

  # tests
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pynput";
  version = "1.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "moses-palmer";
    repo = "pynput";
    tag = "v${version}";
    hash = "sha256-LoolcMYzurJrR7HR1qDO+dvLwP1l9P3+QOzI7uwLdso=";
  };
  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'sphinx >=1.3.1'," "" \
      --replace-fail "'twine >=4.0']" "]"
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-lint
    sphinx
  ];

  propagatedBuildInputs = [
    six
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    evdev
    python-xlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # the darwin backend imports HIServices (ApplicationServices) and Quartz
    pyobjc-framework-ApplicationServices
    pyobjc-framework-Quartz
  ];

  doCheck = false; # requires running X server

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "Library to control and monitor input devices";
    homepage = "https://github.com/moses-palmer/pynput";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ nickhu ];
  };
}
