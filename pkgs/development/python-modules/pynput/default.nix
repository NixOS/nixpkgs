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
  darwin,
  six,

  # tests
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pynput";
  version = "1.7.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "moses-palmer";
    repo = "pynput";
    rev = "refs/tags/v${version}";
    hash = "sha256-6PwfFU1f/osEamSX9kxpOl2wDnrQk5qq1kHi2BgSHes=";
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

  propagatedBuildInputs =
    [ six ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      evdev
      xlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        ApplicationServices
        Quartz
      ]
    );

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
