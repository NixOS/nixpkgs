{ lib
, stdenvNoCC
, fetchFromGitHub
, perlPackages
, perl
, installShellFiles
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
  ];

  buildInputs = [
    perlPackages.XMLTokeParser
  ];

  dontBuild = true;

  # File installation and setup similar to Makefile commands below.
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    perl xmltoman xml/xmltoman.1.xml > xmltoman.1
    perl xmltoman xml/xmlmantohtml.1.xml > xmlmantohtml.1
    install -d $out/bin $out/share/xmltoman
    install -m 0755 xmltoman xmlmantohtml $out/bin
    install -m 0644 xmltoman.dtd xmltoman.css xmltoman.xsl $out/share/xmltoman
    installManPage *.1

    runHook postInstall
  '';

  meta = with lib; {
    description = "Two very simple scripts for converting xml to groff or html";
    homepage = "https://github.com/atsb/xmltoman";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ tochiaha ];
    mainProgram = "xmltoman";
    platforms = platforms.all;
  };
}
