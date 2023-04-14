{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, check
, subunit
, python3Packages

, withDoc ? false
, graphviz-nox

, withExamples ? false

, withEncryption ? false # or "openssl" or "mbedtls"
, openssl
, mbedtls

, withPubSub ? false

# for passthru.tests only
, open62541
}:

let
  encryptionBackend = {
    inherit openssl mbedtls;
  }."${withEncryption}" or (throw "Unsupported encryption backend: ${withEncryption}");
in

stdenv.mkDerivation (finalAttrs: {
  pname = "open62541";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "open62541";
    repo = "open62541";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-X0kdMKSqKAJvmrd1YcYe1mJpFONqPCALA09xwd6o7BQ=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      name = "Ensure-absolute-paths-in-pkg-config-file.patch";
      url = "https://github.com/open62541/open62541/commit/023d4b6b8bdec987f8f3ffee6c09801bbee4fa2d.patch";
      sha256 = "sha256-mq4h32js2RjI0Ljown/01SXA3gc+7+zX8meIcvDPvoA=";
    })
  ];

  cmakeFlags = [
    "-DOPEN62541_VERSION=v${finalAttrs.version}"

    "-DBUILD_SHARED_LIBS=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
    "-DUA_NAMESPACE_ZERO=FULL"

    "-DUA_BUILD_UNIT_TESTS=${if finalAttrs.doCheck then "ON" else "OFF"}"
  ]
  ++ lib.optional withExamples "-DUA_BUILD_EXAMPLES=ON"
  ++ lib.optional (withEncryption != false)
    "-DUA_ENABLE_ENCRYPTION=${lib.toUpper withEncryption}"
  ++ lib.optional withPubSub "-DUA_ENABLE_PUBSUB=ON"
  ;

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.python
  ]
  ++ lib.optionals withDoc (with python3Packages; [
    sphinx
    sphinx_rtd_theme
    graphviz-nox
  ]);

  buildInputs = lib.optional (withEncryption != false) encryptionBackend;

  buildFlags = [ "all" ] ++ lib.optional withDoc "doc";

  doCheck = true;

  checkInputs = [
    check
    subunit
  ];

  # Tests must run sequentially to avoid port collisions on localhost
  enableParallelChecking = false;

  preCheck = let
    disabledTests =
      lib.optionals (withEncryption == "mbedtls") [
        "encryption_basic128rsa15"
      ]
      ++ lib.optionals withPubSub [
        # "Cannot set socket option IP_ADD_MEMBERSHIP"
        "pubsub_publish"
        "check_pubsub_get_state"
        "check_pubsub_publish_rt_levels"
        "check_pubsub_subscribe_config_freeze"
        "check_pubsub_subscribe_rt_levels"
        "check_pubsub_multiple_subscribe_rt_levels"
      ];
    regex = "^(${builtins.concatStringsSep "|" disabledTests})\$";
  in lib.optionalString (disabledTests != []) ''
    checkFlagsArray+=(ARGS="-E ${lib.escapeRegex regex}")
  '';

  postInstall = lib.optionalString withDoc ''
    # excluded files, see doc/CMakeLists.txt
    rm -r doc/{_sources/,CMakeFiles/,cmake_install.cmake}

    # doc is not installed automatically
    mkdir -p $out/share/doc/open62541
    cp -r doc/ $out/share/doc/open62541/html
  '' + lib.optionalString withExamples ''
    # install sources of examples
    mkdir -p $out/share/open62541
    cp -r ../examples $out/share/open62541

    ${lib.optionalString (!stdenv.hostPlatform.isWindows) ''
    # remove .exe suffix
    mv -v $out/bin/ua_server_ctt.exe $out/bin/ua_server_ctt
    ''}

    # remove duplicate libraries in build/bin/, which cause forbidden
    # references to /build/ in ua_server_ctt
    rm -r bin/libopen62541*
  '';

  passthru.tests = let
    open62541Full = encBackend: open62541.override {
      withDoc = true;
      # if (withExamples && withPubSub), one of the example currently fails to build
      #withExamples = true;
      withEncryption = encBackend;
      withPubSub = true;
    };
  in {
    open62541Full = open62541Full false;
    open62541Full-openssl = open62541Full "openssl";
    open62541Full-mbedtls = open62541Full "mbedtls";
  };

  meta = with lib; {
    description = "Open source implementation of OPC UA";
    longDescription = ''
      open62541 (http://open62541.org) is an open source and free implementation
      of OPC UA (OPC Unified Architecture) written in the common subset of the
      C99 and C++98 languages.
      The library is usable with all major compilers and provides the necessary
      tools to implement dedicated OPC UA clients and servers, or to integrate
      OPC UA-based communication into existing applications.
    '';
    homepage = "https://www.open62541.org";
    license = licenses.mpl20;
    maintainers = with maintainers; [ panicgh ];
    platforms = platforms.linux;
  };
})
