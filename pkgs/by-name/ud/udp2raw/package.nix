{
  lib,
  stdenv,
  fetchFromGitHub,
  gnumake,
  makeWrapper,
  iptables,
  glibc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "udp2raw";
  version = "20230206.0";

  src = fetchFromGitHub {
    owner = "wangyu-";
    repo = "udp2raw";
    rev = finalAttrs.version;
    hash = "sha256-mchSaqw6sOJ7+dydCM8juP7QMOVUrPL4MFA79Rvyjdo=";
  };

  nativeBuildInputs = [
    gnumake
    makeWrapper
  ];

  buildInputs = [
    iptables
    glibc.static
  ];

  postPatch = ''
    echo 'const char *gitversion = "${finalAttrs.version}";' > git_version.h
  '';

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    make -o git_version cc_local=${stdenv.cc}/bin/g++
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 udp2raw "$out/bin/udp2raw"
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram "$out/bin/udp2raw" \
      --prefix PATH : "${lib.makeBinPath [ iptables ]}"
  '';

  meta = {
    homepage = "https://github.com/wangyu-/udp2raw";
    description = "Tunnel which turns UDP traffic into encrypted UDP/FakeTCP/ICMP traffic by using a raw socket";
    mainProgram = "udp2raw";
    license = lib.licenses.mit;
    changelog = "https://github.com/wangyu-/udp2raw/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ chvp ];
    platforms = lib.platforms.linux;
  };
})
