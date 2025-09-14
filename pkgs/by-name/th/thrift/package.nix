{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  zlib,
  libevent,
  openssl,
  python3,
  cmake,
  pkg-config,
  bison,
  flex,
  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "thrift";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "thrift";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gGAO+D0A/hEoHMm6OvRBc1Mks9y52kfd0q/Sg96pdW4=";
  };

  # Workaround to make the Python wrapper not drop this package:
  # pythonFull.buildEnv.override { extraLibs = [ thrift ]; }
  pythonPath = [ ];

  nativeBuildInputs = [
    bison
    cmake
    flex
    pkg-config
    (python3.withPackages (
      ps:
      with ps;
      [
        setuptools
        six
      ]
      ++ lib.optionals (!static) [
        twisted
      ]
    ))
  ];

  buildInputs = [
    boost
  ];

  strictDeps = true;

  propagatedBuildInputs = [
    libevent
    openssl
    zlib
  ];

  preConfigure = ''
    export PY_PREFIX=$out
  '';

  cmakeFlags = [
    "-DBUILD_JAVASCRIPT:BOOL=OFF"
    "-DBUILD_NODEJS:BOOL=OFF"

    # FIXME: Fails to link in static mode with undefined reference to
    # `boost::unit_test::unit_test_main(bool (*)(), int, char**)'
    "-DBUILD_TESTING:BOOL=${if static then "OFF" else "ON"}"
  ]
  ++ lib.optionals static [
    "-DWITH_STATIC_LIB:BOOL=ON"
    "-DOPENSSL_USE_STATIC_LIBS=ON"
  ];

  doCheck = !static;

  checkPhase = ''
    runHook preCheck

    ${lib.optionalString stdenv.hostPlatform.isDarwin "DY"}LD_LIBRARY_PATH=$PWD/lib ctest -E "($(echo "$disabledTests" | tr " " "|"))"

    runHook postCheck
  '';

  enableParallelChecking = false;

  meta = with lib; {
    description = "Library for scalable cross-language services";
    mainProgram = "thrift";
    homepage = "https://thrift.apache.org/";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor ];
  };
})
