{
  lib,
  stdenv,
  fetchFromGitHub,
  ocamlPackages,
  copyDesktopItems,
  makeDesktopItem,
  wrapGAppsHook3,
  gsettings-desktop-schemas,
  enableX11 ? !stdenv.hostPlatform.isDarwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unison";
  version = "2.53.7";

  src = fetchFromGitHub {
    owner = "bcpierce00";
    repo = "unison";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QmYcxzsnbRDQdqkLh82OLWrLF6v3qzf1aOIcnz0kwEk=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    ocamlPackages.ocaml
    ocamlPackages.findlib
  ]
  ++ lib.optionals enableX11 [
    copyDesktopItems
    wrapGAppsHook3
  ];
  buildInputs = lib.optionals enableX11 [
    gsettings-desktop-schemas
    ocamlPackages.lablgtk3
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ]
  ++ lib.optionals (!ocamlPackages.ocaml.nativeCompilers) [ "NATIVE=false" ];

  postInstall = lib.optionalString enableX11 ''
    install -D $src/icons/U.svg $out/share/icons/hicolor/scalable/apps/unison.svg
  '';

  dontStrip = !ocamlPackages.ocaml.nativeCompilers;

  desktopItems = lib.optional enableX11 (makeDesktopItem {
    name = finalAttrs.pname;
    desktopName = "Unison";
    comment = "Bidirectional file synchronizer";
    genericName = "File synchronization tool";
    exec = "unison-gui";
    icon = "unison";
    categories = [
      "Utility"
      "FileTools"
      "GTK"
    ];
    startupNotify = true;
    startupWMClass = "Unison";
  });

  meta = {
    homepage = "https://www.cis.upenn.edu/~bcpierce/unison/";
    description = "Bidirectional file synchronizer";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ nevivurn ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin && enableX11; # unison-gui and uimac are broken on darwin
    mainProgram = if enableX11 then "unison-gui" else "unison";
  };
})
