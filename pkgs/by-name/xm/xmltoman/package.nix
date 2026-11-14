{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  perlPackages,
  perl,
  installShellFiles,
}:

stdenvNoCC.mkDerivation rec {
  pname = "xmltoman";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "atsb";
    repo = "xmltoman";
    rev = version;
    hash = "sha256-EmFdGIeBEcTY0Pqp7BJded9WB/DaXWcMNWh6aTsZlLg=";
  };

  nativeBuildInputs = [
    perl
    installShellFiles
    makeWrapper
  ];

  buildInputs = [
    perlPackages.XMLTokeParser
  ];

  dontBuild = true;

  # File installation and setup similar to Makefile commands below.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/xmltoman
    install -m 0755 xmltoman xmlmantohtml "$out/bin"
    patchShebangs "$out/bin/xmltoman" "$out/bin/xmlmantohtml"
    wrapProgram "$out/bin/xmltoman" --set PERL5LIB $PERL5LIB
    wrapProgram "$out/bin/xmlmantohtml" --set PERL5LIB $PERL5LIB

    "$out/bin/xmltoman" xml/xmltoman.1.xml > xmltoman.1
    "$out/bin/xmltoman" xml/xmlmantohtml.1.xml > xmlmantohtml.1
    install -m 0644 xmltoman.dtd xmltoman.css xmltoman.xsl $out/share/xmltoman
    installManPage *.1

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheckPhase

    "$out/bin/xmltoman" <(echo '<xml/>')
    "$out/bin/xmlmantohtml" <(echo '<xml/>')

    runHook postInstallCheckPhase
  '';

  meta = {
    description = "Two very simple scripts for converting xml to groff or html";
    homepage = "https://github.com/atsb/xmltoman";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "xmltoman";
    platforms = lib.platforms.all;
  };
}
