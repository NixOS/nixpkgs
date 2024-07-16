{ lib
, stdenv
, fetchFromGitLab
, perl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tnscmd10g";
  version = "1.3";

  src = fetchFromGitLab {
    group = "kalilinux";
    owner = "packages";
    repo = "tnscmd10g";
    rev = "upstream/${finalAttrs.version}";
    hash = "sha256-hh1am/TdLcd3w4tvrYA4nL/kgRdEwQhi6yCKSx6eNQg=";
  };

  buildInputs = [
    perl
  ];

  installPhase = ''
    runHook preInstall

    install -D tnscmd10g $out/bin/tnscmd10g

    runHook postInstall
  '';

  meta = {
    description = "Tool to enumerate the oracle tnslsnr process (1521/tcp)";
    homepage = "http://www.red-database-security.com";
    license = lib.licenses.gpl2Plus;
    mainProgram = "tnscmd10g";
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = lib.platforms.all;
  };
})
