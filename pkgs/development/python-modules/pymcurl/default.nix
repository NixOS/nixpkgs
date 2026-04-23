{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  cffi,
  curl,

  pytestCheckHook,
  pytest-httpbin,
}:

buildPythonPackage (finalAttrs: {
  pname = "pymcurl";
  version = "8.19.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "genotrance";
    repo = "mcurl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CryRcVAqax+QV/aK9nld14ZSqVq2vngck8z6vJa3Zlg=";
  };

  # jbb tries to fetch libcurl from binarybuilder.org;
  # patch it out.
  patches = [
    ./0001-patch-out-jbb.patch
  ];

  postPatch = ''
    substituteInPlace mcurl/gen.py \
      --replace-warn @curl-libdir@ "${curl}/lib" \
      --replace-warn @curl-header@ "${curl.dev}/include/curl/curl.h"
  '';

  build-system = [
    setuptools
  ];

  buildInputs = [
    curl
    curl.dev
    stdenv
  ];

  dependencies = [
    cffi
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-httpbin
  ];

  pythonImportCheck = [
    "mcurl"
  ];

  meta = {
    description = "Manage outbound HTTP connections using Curl & CurlMulti";
    longDescription = ''
      Python wrapper for libcurl with a high-level API for the easy
      and multi interfaces. Originally created for the Px proxy
      server.
    '';
    homepage = "https://github.com/genotrance/mcurl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luc65r ];
    platforms = lib.platforms.all;
  };
})
