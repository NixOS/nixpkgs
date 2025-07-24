{
  lib,
  stdenv,
  fetchpatch,
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

stdenv.mkDerivation rec {
  pname = "thrift";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "thrift";
    tag = "v0.21.0";
    hash = "sha256-OF/pFG8OXROsyYGf6jgfVTYTrTc8UB5QJh4gbostFfU=";
  };

  # Workaround to make the Python wrapper not drop this package:
  # pythonFull.buildEnv.override { extraLibs = [ thrift ]; }
  pythonPath = [ ];

  nativeBuildInputs =
    [
      bison
      cmake
      flex
      pkg-config
      python3
      python3.pkgs.setuptools
    ]
    ++ lib.optionals (!static) [
      python3.pkgs.twisted
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

  cmakeFlags =
    [
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
}
