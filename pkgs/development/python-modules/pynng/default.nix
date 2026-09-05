{
  lib,
  cmake,
  ninja,
  buildPythonPackage,
  applyPatches,
  fetchFromGitHub,
  isPyPy,
  scikit-build-core,
  headerkit,
  setuptools-scm,
  cffi,
  sniffio,
  pytest,
  trio,
  pytest-trio,
  pytest-asyncio,
}:
let
  src = fetchFromGitHub {
    owner = "codypiersall";
    repo = "pynng";
    rev = "fb03025298dd40ea49fdeb0034ce6bfff055bce3";
    hash = "sha256-ujSi8pjOVS4OzYUQdX/b568OJncrvABiReItkJcnsME=";
  };

  nng = applyPatches {
    src = fetchFromGitHub {
      owner = "nanomsg";
      repo = "nng";
      tag = "v1.11";
      hash = "sha256-yH/iK/DuVff2qby/wk6jJ9Tsmxrl9eMrb9bOxCzvmdA=";
    };
    patches = [ "${src}/patches/nng-mbedtls-hostname.patch" ];
  };

  mbedtls = fetchFromGitHub {
    owner = "ARMmbed";
    repo = "mbedtls";
    tag = "v3.6.5";
    hash = "sha256-CAMksh7i4mg5zVTYLB/SZWFVmgQBMhPnislLCD9j7+o=";
    fetchSubmodules = true;
  };
in
buildPythonPackage (finalAttrs: {
  pname = "pynng";
  version = "0.9.0-unstable-2026-03-22";
  pyproject = true;

  disabled = isPyPy;

  inherit src;

  postPatch =
    let
      version = lib.head (lib.strings.splitString "-" finalAttrs.version);
    in
    ''
      substituteInPlace pyproject.toml \
        --replace-fail 'dynamic = ["version"]' 'version = "${version}"' \
        --replace-fail '"cffi_buildtool",' ""

      substituteInPlace CMakeLists.txt \
        --replace-fail "cffi_buildtool" "cffi.gen_src"
    '';

  nativeBuildInputs = [
    cmake
    ninja
  ];

  build-system = [
    scikit-build-core
    cffi
    headerkit
    setuptools-scm
  ];

  dontUseCmakeConfigure = true;
  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_NNG" "${nng}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MBEDTLS" "${mbedtls}")
  ];

  dependencies = [
    cffi
    sniffio
    pytest
    trio
    pytest-trio
    pytest-asyncio
  ];

  pythonImportsCheck = [ "pynng" ];

  meta = {
    description = "Python bindings for Nanomsg Next Generation";
    homepage = "https://github.com/codypiersall/pynng";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ afermg ];
    platforms = lib.platforms.all;
  };
})
