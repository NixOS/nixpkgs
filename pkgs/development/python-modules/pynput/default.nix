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
  xlib,
  evdev,
  six,

  # tests
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pynput";
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "moses-palmer";
    repo = "pynput";
    tag = "v${version}";
    hash = "sha256-rOkUyreS3JqEyubQUdNLJf5lDuFassDKrQrUXKrKlgI=";
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
    xlib
  ];

  doCheck = false; # requires running X server

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Library to control and monitor input devices";
    homepage = "https://github.com/moses-palmer/pynput";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ nickhu ];
  };
}
