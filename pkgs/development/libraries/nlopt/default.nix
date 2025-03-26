{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  # Optionally build Python bindings
  withPython ? false,
  python3,
  python3Packages,
  swig,
  # Optionally build Octave bindings
  withOctave ? false,
  octave,
  # Build static on-demand
  withStatic ? stdenv.hostPlatform.isStatic,
}:
let
  buildPythonBindingsEnv = python3.withPackages (p: [ p.numpy ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nlopt";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "stevengj";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-TgieCX7yUdTAEblzXY/gCN0r6F9TVDh4RdNDjQdXZ1o=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs =
    [ cmake ]
    ## Building the python bindings requires SWIG, and numpy in addition to the CXX routines.
    ## The tests also make use of the same interpreter to test the bindings.
    ++ lib.optionals withPython [
      swig
      buildPythonBindingsEnv
    ]
    ## Building octave bindings requires `mkoctfile` to be installed.
    ++ lib.optional withOctave octave;

  # Python bindings depend on numpy at import time.
  propagatedBuildInputs = lib.optional withPython python3Packages.numpy;

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if !withStatic then "ON" else "OFF"}"
    "-DNLOPT_CXX=ON"
    "-DNLOPT_PYTHON=${if withPython then "ON" else "OFF"}"
    "-DNLOPT_OCTAVE=${if withOctave then "ON" else "OFF"}"
    "-DNLOPT_SWIG=${if withPython then "ON" else "OFF"}"
    "-DNLOPT_FORTRAN=OFF"
    "-DNLOPT_MATLAB=OFF"
    "-DNLOPT_GUILE=OFF"
    "-DNLOPT_TESTS=${if finalAttrs.doCheck then "ON" else "OFF"}"
  ] ++ lib.optional withPython "-DPython_EXECUTABLE=${buildPythonBindingsEnv.interpreter}";

  doCheck = true;

  postFixup = ''
    substituteInPlace $dev/lib/cmake/nlopt/NLoptLibraryDepends.cmake --replace-fail \
      'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/' 'INTERFACE_INCLUDE_DIRECTORIES "'
  '';

  meta = {
    homepage = "https://nlopt.readthedocs.io/en/latest/";
    changelog = "https://github.com/stevengj/nlopt/releases/tag/v${finalAttrs.version}";
    description = "Free open-source library for nonlinear optimization";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.bengsparks ];
  };
})
