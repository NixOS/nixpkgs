{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  gitUpdater,
  # Optionally build Python bindings
  withPython ? false,
  python3,
  python3Packages,
  # Optionally build Octave bindings
  withOctave ? false,
  octave,
  # Optionally build Java bindings
  withJava ? false,
  jdk,
  # Required for building the Python and Java bindings
  swig,
  # Optionally exclude Luksan solvers to allow licensing under MIT
  withoutLuksanSolvers ? false,
  # Build static on-demand
  withStatic ? stdenv.hostPlatform.isStatic,
}:
let
  buildPythonBindingsEnv = python3.withPackages (p: [ p.numpy ]);
  buildDocsEnv = python3.withPackages (p: [
    p.mkdocs
    p.python-markdown-math
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nlopt";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "stevengj";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-mZRmhXrApxfiJedk+L/poIP2DR/BkV04c5fiwPGAyjI=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  patches = [
    # 26-03-2025: `mkdocs.yml` is missing a link for the subpage related to the Java bindings.
    # 26-03-2025: This commit was merged after v2.10.0 was released, and has not been made
    # 26-03-2025: part of a release.
    (fetchpatch {
      name = "missing-java-reference-mkdocs";
      url = "https://github.com/stevengj/nlopt/commit/7e34f1a6fe82ed27daa6111d83c4d5629555454b.patch";
      hash = "sha256-XivfZtgIGLyTtU+Zo2jSQAx2mVdGLJ8PD7VSSvGR/5Q=";
    })

    # 26-03-2025: The docs pages still list v2.7.1 as the newest version.
    # 26-03-2025: This commit was merged after v2.10.0 was released, and has not been made
    # 26-03-2025: part of a release.
    (fetchpatch {
      name = "update-index-md";
      url = "https://github.com/stevengj/nlopt/commit/2c4147832eff7ea15d0536c82351a9e169f85e43.patch";
      hash = "sha256-BXcbNUyu20f3N146v6v9cpjSj5CwuDtesp6lAqOK2KY=";
    })

    # 26-03-2025: There is an off-by-one error in the test/CMakeLists.txt
    # 26-03-2025: that causes the tests to attempt to run disabled Luksan solver code,
    # 26-03-2025: which in turn causes the test suite to fail.
    # 26-03-2025: See https://github.com/stevengj/nlopt/pull/605
    (fetchpatch {
      name = "fix-nondisabled-luksan-algorithm";
      url = "https://github.com/stevengj/nlopt/commit/7817ec19f21be6877a4b79777fc5315a52c6850b.patch";
      hash = "sha256-KgdAMSYKOQuraun4HNr9GOx48yjyeQk6W3IgWRA44oo=";
    })
  ];

  postPatch = ''
    substituteInPlace nlopt.pc.in \
      --replace-fail 'libdir=''${exec_prefix}/@NLOPT_INSTALL_LIBDIR@' 'libdir=@NLOPT_INSTALL_LIBDIR@'
  '';

  nativeBuildInputs =
    [ cmake ]
    ## Building the python bindings requires SWIG, and numpy in addition to the CXX routines.
    ## The tests also make use of the same interpreter to test the bindings.
    ++ lib.optionals withPython [
      swig
      buildPythonBindingsEnv
    ]
    ## Building the java bindings requires Swig, C++, JNI and Java
    ++ lib.optionals withJava [
      swig
      jdk
    ]
    ## Building octave bindings requires `mkoctfile` to be installed.
    ++ lib.optional withOctave octave;

  # Python bindings depend on numpy at import time.
  propagatedBuildInputs = lib.optional withPython python3Packages.numpy;

  separateDebugInfo = true;

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    "-DBUILD_SHARED_LIBS=${if !withStatic then "ON" else "OFF"}"
    "-DNLOPT_CXX=ON"
    "-DNLOPT_PYTHON=${if withPython then "ON" else "OFF"}"
    "-DNLOPT_OCTAVE=${if withOctave then "ON" else "OFF"}"
    "-DNLOPT_JAVA=${if withJava then "ON" else "OFF"}"
    "-DNLOPT_SWIG=${if withPython || withJava then "ON" else "OFF"}"
    "-DNLOPT_FORTRAN=OFF"
    "-DNLOPT_MATLAB=OFF"
    "-DNLOPT_GUILE=OFF"
    "-DNLOPT_LUKSAN=${if !withoutLuksanSolvers then "ON" else "OFF"}"
    "-DNLOPT_TESTS=${if finalAttrs.doCheck then "ON" else "OFF"}"
  ] ++ lib.optional withPython "-DPython_EXECUTABLE=${buildPythonBindingsEnv.interpreter}";

  postBuild = ''
    ${buildDocsEnv.interpreter} -m mkdocs build \
      --config-file ../mkdocs.yml \
      --site-dir $doc \
      --no-directory-urls
  '';

  doCheck = true;

  postFixup = ''
    substituteInPlace $dev/lib/cmake/nlopt/NLoptLibraryDepends.cmake --replace-fail \
      'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/' 'INTERFACE_INCLUDE_DIRECTORIES "'
  '';

  passthru.updateScript = gitUpdater {
    # Releases are prefixed with v
    rev-prefix = "v";
    # Prefix for versions pre v2.5.0
    ignoredVersions = "^nlopt-.*$";
  };

  meta = {
    homepage = "https://nlopt.readthedocs.io/en/latest/";
    changelog = "https://github.com/stevengj/nlopt/releases/tag/v${finalAttrs.version}";
    description = "Free open-source library for nonlinear optimization";
    license = if withoutLuksanSolvers then lib.licenses.mit else lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.bengsparks ];
  };
})
