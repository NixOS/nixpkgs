{
  lib,
  stdenv,
  fetchFromGitHub,

  withJson ? true,
  withHttps ? true,
  withWebsockets ? true,
  withCurl ? true,
  withLogger ? true,
  withUwsc ? withWebsockets, # uwsc depends on websockets

  # nativeBuildInputs
  cmake,

  # Optional dependencies
  curl,
  gnutls,
  jansson,
  libmicrohttpd,
  orcania,
  yder,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ulfius";
  version = "2.7.15";

  src = fetchFromGitHub {
    owner = "babelouest";
    repo = "ulfius";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YvMhcobvTEm4LxhNxi1MJX8N7VAB3YOvp+LxioJrKHU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    libmicrohttpd
    orcania
  ]
  ++ lib.optionals withJson [ jansson ]
  ++ lib.optionals withCurl [ curl ]
  ++ lib.optionals (withHttps || withWebsockets) [ gnutls ]
  ++ lib.optionals withLogger [ yder ]
  ++ lib.optionals withWebsockets [ zlib ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_CURL" withCurl)
    (lib.cmakeBool "WITH_JANSSON" withJson)
    (lib.cmakeBool "WITH_GNUTLS" (withHttps || withWebsockets))
    (lib.cmakeBool "WITH_YDER" withLogger)
    (lib.cmakeBool "BUILD_UWSC" (withUwsc && withWebsockets))
    (lib.cmakeBool "WITH_WEBSOCKET" withWebsockets)
    (lib.cmakeBool "WITH_WEBSOCKET_MESSAGE_LIST" withWebsockets)
  ];

  meta = {
    description = "Web Framework to build REST APIs, Webservices or any HTTP endpoint in C language. Can stream large amount of data, integrate JSON data with Jansson, and create websocket services";
    homepage = "https://github.com/babelouest/ulfius";
    changelog = "https://github.com/babelouest/ulfius/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.all;
  }
  // lib.optionalAttrs (withUwsc && withWebsockets) { mainProgram = "uwsc"; };
})
