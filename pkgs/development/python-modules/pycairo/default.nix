{
  lib,
  pythonOlder,
  fetchFromGitHub,
  meson,
  ninja,
  buildPythonPackage,
  pytestCheckHook,
  pkg-config,
  cairo,
  libxcrypt,
  python,
}:

buildPythonPackage rec {
  pname = "pycairo";
  version = "1.28.0";

  disabled = pythonOlder "3.6";

  format = "other";

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

  buildInputs = [ cairo ] ++ lib.optionals (pythonOlder "3.9") [ libxcrypt ];

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

  meta = with lib; {
    description = "Python 3 bindings for cairo";
    homepage = "https://pycairo.readthedocs.io/";
    license = with licenses; [
      lgpl21Only
      mpl11
    ];
    platforms = platforms.unix;
  };
}
