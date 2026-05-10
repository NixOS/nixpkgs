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

buildPythonPackage {
  pname = "pynputfix";
  version = "1.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AuroraWright";
    repo = "pynputfix";
    tag = "1.8.2";
    hash = "sha256-SKw745hh0G2NoWgUUjShyjiG2NYPd4iJlWx7IeGpW/4=";
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

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Library to control and monitor input devices";
    homepage = "https://github.com/moses-palmer/pynput";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
