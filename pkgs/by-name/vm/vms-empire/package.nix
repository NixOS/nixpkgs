{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  xmlto,
  docbook_xml_dtd_44,
  docbook_xsl,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vms-empire";
  version = "1.18";

  src = fetchurl {
    url = "http://www.catb.org/~esr/vms-empire/vms-empire-${finalAttrs.version}.tar.gz";
    hash = "sha256-JWCmrGS4jClSi6MCcGNiq8zUH+92fiqMtk58B+wMKQk=";
  };

  nativeBuildInputs = [
    installShellFiles
    xmlto
    docbook_xml_dtd_44
    docbook_xsl
  ];

  buildInputs = [
    ncurses
  ];

  outputs = [
    "out"
    "doc"
    "man"
  ];

  strictDeps = true;

  postBuild = ''
    xmlto man vms-empire.xml
    xmlto html-nochunks vms-empire.xml
  '';

  installPhase = ''
    runHook preInstall
    install -D vms-empire -t ${placeholder "out"}/bin/
    install -D vms-empire.html -t ${placeholder "doc"}/share/doc/vms-empire/
    install -D vms-empire.desktop -t ${placeholder "out"}/share/applications/
    install -D vms-empire.png -t ${placeholder "out"}/share/icons/hicolor/48x48/apps/
    install -D vms-empire.xml -t ${placeholder "out"}/share/appdata/
    installManPage empire.6
    runHook postInstall
  '';

  meta = {
    homepage = "http://catb.org/~esr/vms-empire/";
    description = "Ancestor of all expand/explore/exploit/exterminate games";
    longDescription = ''
      Empire is a simulation of a full-scale war between two emperors, the
      computer and you. Naturally, there is only room for one, so the object of
      the game is to destroy the other. The computer plays by the same rules
      that you do. This game was ancestral to all later
      expand/explore/exploit/exterminate games, including Civilization and
      Master of Orion.
    '';
    license = lib.licenses.gpl2Only;
    mainProgram = "vms-empire";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
