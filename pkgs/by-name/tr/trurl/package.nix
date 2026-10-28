{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  curl,
  python3,
  perl,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "trurl";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "curl";
    repo = "trurl";
    rev = "trurl-${version}";
    hash = "sha256-VCMT4WgZ6LG7yiKaRy7KTgTkbACVXb4rw62lWnVAuP0=";
  };

  patches = [
    # fix build w/ glibc-2.44
    # https://github.com/curl/trurl/commit/6e1479cc3bdece8d9a7602e6f8f799305d5a5b7d, but rebased
    ./0001-build-constify-strchr-memchr-results.patch
    (fetchpatch {
      url = "https://github.com/curl/trurl/commit/b3c2faf7ee519e4686248957ee079a2452741d61.patch";
      hash = "sha256-khA77XHPVF+2Vn492UuPrhVAEUijRBA2P8lvPlKYSQM=";
    })

    (fetchpatch {
      url = "https://github.com/curl/trurl/commit/f22a2c45956f35702e437fb83ac05376f1956ec5.patch";
      hash = "sha256-7CkUs5tMk77WKc7SlgE2NslHtU5cViKSGhHj3IBlpWo=";
    })
    # https://github.com/curl/trurl/pull/441 + fix for more tests
    ./tests-uppercase-hex.patch
  ];

  postPatch = ''
    patchShebangs scripts/*
  '';

  outputs = [
    "out"
    "dev"
    "man"
  ];
  separateDebugInfo = stdenv.hostPlatform.isLinux;

  enableParallelBuilding = true;

  nativeBuildInputs = [
    curl
    perl
  ];
  buildInputs = [ curl ];
  makeFlags = [ "PREFIX=$(out)" ];

  strictDeps = true;

  doCheck = true;
  nativeCheckInputs = [ python3 ];
  checkTarget = "test";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Command line tool for URL parsing and manipulation";
    homepage = "https://curl.se/trurl";
    changelog = "https://github.com/curl/trurl/releases/tag/trurl-${version}";
    license = lib.licenses.curl;
    maintainers = with lib.maintainers; [
      christoph-heiss
      diogotcorreia
    ];
    platforms = lib.platforms.all;
    mainProgram = "trurl";
  };
}
