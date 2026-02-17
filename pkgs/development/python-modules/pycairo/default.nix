{
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  buildPythonPackage,
  pytestCheckHook,
  pkg-config,
  cairo,
  python,
}:

buildPythonPackage rec {
  pname = "pycairo";
  version = "1.28.0";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "pygobject";
    repo = "pycairo";
    tag = "v${version}";
    hash = "sha256-OAF1Yv9aoUctklGzH2xM+cVu5csyEnX2AV9n0OeoFUw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [ cairo ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Cairo tries to load system fonts by default.
  # It's surfaced as a Cairo "out of memory" error in tests.
  __impureHostDeps = [ "/System/Library/Fonts" ];

  mesonFlags = [
    # This is only used for figuring out what version of Python is in
    # use, and related stuff like figuring out what the install prefix
    # should be, but it does need to be able to execute Python code.
    "-Dpython=${python.pythonOnBuildForHost.interpreter}"
  ];

  meta = {
    description = "Python 3 bindings for cairo";
    homepage = "https://pycairo.readthedocs.io/";
    license = with lib.licenses; [
      lgpl21Only
      mpl11
    ];
    platforms = lib.platforms.unix;
  };
}
