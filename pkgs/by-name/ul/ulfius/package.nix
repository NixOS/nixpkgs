{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
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

  buildInputs = [
    curl
    gnutls
    jansson
    libmicrohttpd
    orcania
    yder
    zlib
  ];

  meta = {
    description = "Web Framework to build REST APIs, Webservices or any HTTP endpoint in C language. Can stream large amount of data, integrate JSON data with Jansson, and create websocket services";
    homepage = "https://github.com/babelouest/ulfius";
    changelog = "https://github.com/babelouest/ulfius/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "uwsc";
    platforms = lib.platforms.all;
  };
})
