{
  stdenv,
  lib,
  fetchFromGitHub,
  git,
  testers,
  uradvd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uradvd";
  version = "r26-1e64364d";

  nativeBuildInputs = [
    git
  ];

  src = fetchFromGitHub {
    deepClone = true;
    owner = "freifunk-gluon";
    repo = "uradvd";
    rev = "1e64364d323acb8c71285a6fb85d384334e7007d";
    hash = "sha256-+MDhBuCPJ/dcKw4/z4PnXXGoNomIz/0QI32XfLR6fK0=";
  };

  installPhase = ''
    runHook preInstall

    install -D --mode=0755 uradvd -t "$out/bin"

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = uradvd;
    command = "uradvd --version";
    version = "uradvd ${finalAttrs.version}";
  };

  meta = {
    description = "Tiny IPv6 Router Advertisement Daemon";
    homepage = "https://github.com/freifunk-gluon/uradvd";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aiyion ];
    mainProgram = "uradvd";
  };
})
