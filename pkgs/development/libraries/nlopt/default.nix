{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
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
    repo = "nlopt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TgieCX7yUdTAEblzXY/gCN0r6F9TVDh4RdNDjQdXZ1o=";
  };

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

  cmakeFlags =
    [
      (lib.cmakeBool "BUILD_SHARED_LIBS" (!withStatic))
      (lib.cmakeBool "NLOPT_CXX" true)
      (lib.cmakeBool "NLOPT_PYTHON" withPython)
      (lib.cmakeBool "NLOPT_OCTAVE" withOctave)
      (lib.cmakeBool "NLOPT_SWIG" withPython)
      (lib.cmakeBool "NLOPT_FORTRAN" false)
      (lib.cmakeBool "NLOPT_MATLAB" false)
      (lib.cmakeBool "NLOPT_GUILE" false)
      (lib.cmakeBool "NLOPT_TESTS" finalAttrs.doCheck)
    ]
    ++ lib.optional withPython (
      lib.cmakeFeature "Python_EXECUTABLE" "${buildPythonBindingsEnv.interpreter}"
    );

  doCheck = true;

  postFixup = ''
    substituteInPlace $out/lib/cmake/nlopt/NLoptLibraryDepends.cmake --replace-fail \
      'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/' 'INTERFACE_INCLUDE_DIRECTORIES "'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://nlopt.readthedocs.io/en/latest/";
    changelog = "https://github.com/stevengj/nlopt/releases/tag/v${finalAttrs.version}";
    description = "Free open-source library for nonlinear optimization";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.bengsparks ];
  };
})
