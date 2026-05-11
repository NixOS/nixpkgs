{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  pkg-config,
  arpa2cm,
  arpa2common,
  db,
  gnutls,
  ldns,
  libkrb5,
  libtasn1,
  openldap,
  p11-kit,
  quickder,
  unbound,
  openssl,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tlspool";
  version = "0.9.7";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "tlspool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nODnRoFlgCTtBjPief9SkVlLgD3g+2zbwM0V9pt3Crk=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    libkrb5
  ];

  buildInputs = [
    arpa2cm
    arpa2common
    db
    gnutls
    ldns
    libkrb5
    libtasn1
    openldap
    p11-kit
    quickder
    unbound
    openssl
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "TLS daemon with PKCS #11 backend";
    homepage = "https://gitlab.com/arpa2/tlspool";
    changelog = "https://gitlab.com/arpa2/tlspool/-/blob/v${finalAttrs.version}/CHANGES";
    license = with lib.licenses; [
      gpl3Plus # daemon
      cc-by-sa-40 # docs
      bsd2 # userspace
    ];
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = lib.platforms.linux;
    mainProgram = "tlsserver";
  };
})
