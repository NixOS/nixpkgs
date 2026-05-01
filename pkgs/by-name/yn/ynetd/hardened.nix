{
  lib,
  openssl,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ctf-ynetd";
  version = "2024.12.31";

  src = fetchurl {
    url = "https://hxp.io/assets/data/code/ctf-ynetd-2024.12.31.tar.xz";
    hash = "sha256-hUEZZEulmaV3KfKOqE1wl7y4SRUn2/HoOjVDabk5+YA=";
  };

  buildInputs = [ openssl ];

  makeFlags = [
    "ynetd"
    "pow-solver"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 ynetd $out/bin/ynetd
    install -Dm755 pow-solver $out/bin/pow-solver
    runHook postInstall
  '';

  meta = {
    description = "Fork of ynetd hardened for CTFs with isolation using PID namespaces, minimal overhead proof-of-work checking, and strict resource limits via cgroups";
    homepage = "https://hxp.io/code/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.haylin ];
    mainProgram = "ynetd";
  };
})
