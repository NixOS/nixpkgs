{
  lib,
  stdenv,
  fetchFromGitLab,
  arpa2cm,
  arpa2common,
  bison,
  cacert,
  libuuid,
  cmake,
  cyrus_sasl,
  ctestCheckHook,
  e2fsprogs,
  flex,
  freediameter,
  gnutls,
  json_c,
  libev,
  libkrb5,
  libressl,
  openssl,
  pkg-config,
  python3,
  quick-sasl,
  quickder,
  quickmem,
  unbound,
  ragel,
  nix-update-script,
}:
let
  python-with-packages = python3.withPackages (
    ps: with ps; [
      asn1ate
      colored
      pyparsing
      setuptools
      six
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tartaros";
  version = "1.0.1";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "tartaros";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TwSiVdg1fKRDft9bW/wOuuV9VigYtjrg5pWhcXi6jIg=";
  };


  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    # bison
    # cacert
    cmake
    # cyrus_sasl
    # ctestCheckHook
    # flex
    # freediameter
    libkrb5
    # openssl
    pkg-config
    python3
    # unbound
    ragel
  ];

  buildInputs = [
    arpa2cm
    arpa2common
    cyrus_sasl
    # e2fsprogs
    # freediameter
    # gnutls
    # json_c
    libev
    # libkrb5
    # libressl
    libuuid
    # python-with-packages
    quick-sasl
    quickder
    quickmem
    # unbound
  ];

  cmakeFlags = [
    # (lib.cmakeFeature "freeDiameter_EXTENSION_DIR" "${placeholder "out"}/lib/freeDiameter")
  ];

  preBuild = ''
    # patchShebangs test
  '';

  doCheck = true;

  preCheck = ''
    patchShebangs ../test
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Frontend for judgements about your identity, usually through challenge/response interactions, ending in an afterlife with varied rights";
    homepage = "https://gitlab.com/arpa2/tartaros";
    # NO license yet? license = lib.licenses.bsd2;
    teams = with lib.teams; [ ngi ];
  };
})
