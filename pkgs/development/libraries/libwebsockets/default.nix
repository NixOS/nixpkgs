{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
, zlib
, libuv
  # External poll is required for e.g. mosquitto, but discouraged by the maintainer.
, withExternalPoll ? false
}:

stdenv.mkDerivation rec {
  pname = "libwebsockets";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "warmcat";
    repo = "libwebsockets";
    rev = "v${version}";
    hash = "sha256-why8LAcc4XN0JdTJ1JoNWijKENL5mOHBsi9K4wpYr2c=";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ openssl zlib libuv ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DLWS_WITH_PLUGINS=ON"
    "-DLWS_WITH_IPV6=ON"
    "-DLWS_WITH_SOCKS5=ON"
    "-DDISABLE_WERROR=ON"
    "-DLWS_BUILD_HASH=no_hash"
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "-DLWS_WITHOUT_TESTAPPS=ON"
  ++ lib.optional withExternalPoll "-DLWS_WITH_EXTERNAL_POLL=ON"
  ++ (
    if stdenv.hostPlatform.isStatic then
      [ "-DLWS_WITH_SHARED=OFF" ]
    else
      [ "-DLWS_WITH_STATIC=OFF" "-DLWS_LINK_TESTAPPS_DYNAMIC=ON" ]
  );

  postInstall = ''
    # Fix path that will be incorrect on move to "dev" output.
    substituteInPlace "$out/lib/cmake/libwebsockets/LibwebsocketsTargets-release.cmake" \
      --replace "\''${_IMPORT_PREFIX}" "$out"

    # The package builds a few test programs that are not usually necessary.
    # Move those to the dev output.
    moveToOutput "bin/libwebsockets-test-*" "$dev"
    moveToOutput "share/libwebsockets-test-*" "$dev"
  '';

  # $out/share/libwebsockets-test-server/plugins/libprotocol_*.so refers to crtbeginS.o
  disallowedReferences = [ stdenv.cc.cc ];

  meta = with lib; {
    description = "Light, portable C library for websockets";
    longDescription = ''
      Libwebsockets is a lightweight pure C library built to
      use minimal CPU and memory resources, and provide fast
      throughput in both directions.
    '';
    homepage = "https://libwebsockets.org/";
    # Relicensed from LGPLv2.1+ to MIT with 4.0. Licensing situation
    # is tricky, see https://github.com/warmcat/libwebsockets/blob/main/LICENSE
    license = with licenses; [ mit publicDomain bsd3 asl20 ];
    maintainers = with maintainers; [ mindavi ];
    platforms = platforms.all;
  };
}

