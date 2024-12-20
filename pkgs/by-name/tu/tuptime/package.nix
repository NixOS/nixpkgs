{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  python3,
  sqlite,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "tuptime";
  version = "5.2.4";

  src = fetchFromGitHub {
    owner = "rfmoz";
    repo = "tuptime";
    rev = version;
    sha256 = "sha256-pYGtgv9hPBG/URD2nOWg6qJYYLtlqLW+t5mCLpzKlEc=";
  };

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  buildInputs = [ python3 ];

  outputs = [
    "out"
    "man"
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 $src/src/tuptime $out/bin/

    installManPage $src/src/man/tuptime.1

    install -Dm 0755 $src/misc/scripts/db-tuptime-migrate-4.0-to-5.0.sh \
      $out/share/tuptime/db-tuptime-migrate-4.0-to-5.0.sh
  '';

  preFixup = ''
    wrapProgram $out/share/tuptime/db-tuptime-migrate-4.0-to-5.0.sh \
      --prefix PATH : "${lib.makeBinPath [ sqlite ]}"
  '';

  passthru.tests = nixosTests.tuptime;

  meta = with lib; {
    description = "Total uptime & downtime statistics utility";
    homepage = "https://github.com/rfrail3/tuptime";
    changelog = "https://github.com/rfrail3/tuptime/blob/master/CHANGELOG";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.evils ];
    mainProgram = "tuptime";
  };
}
