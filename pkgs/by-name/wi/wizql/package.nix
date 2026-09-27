{
  autoPatchelfHook,
  desktop-file-utils,
  dpkg,
  fetchurl,
  gtk3,
  lib,
  libsoup_3,
  makeBinaryWrapper,
  stdenvNoCC,
  webkitgtk_4_1,
  xdotool,
}:

let
  gtk = gtk3;
  libsoup = libsoup_3;
  webkitgtk = webkitgtk_4_1;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wizql";
  version = "1.7.0";

  src = fetchurl (
    let
      version = finalAttrs.version;
      sources = {
        "aarch64-darwin" = {
          url = "https://github.com/razein97/Wizql-Issue-Tracker/releases/download/${version}/WizQl_${version}_aarch64.app.tar.gz";
          hash = "sha256-/1q/918yhJal8MAT1SmGrnZ3//oEKYJCLaGahk3IvKA=";
        };
        "x86_64-darwin" = {
          url = "https://github.com/razein97/Wizql-Issue-Tracker/releases/download/${version}/WizQl_${version}_x64.app.tar.gz";
          hash = "sha256-Clrk4tUZPdWTuYt5qSG0kwUejdfeAu8uACIG4aCbQNQ=";
        };
        "aarch64-linux" = {
          url = "https://github.com/razein97/Wizql-Issue-Tracker/releases/download/${version}/WizQl_${version}_arm64.deb";
          hash = "sha256-EgrU4fcVjk3CJ9Wl5FDmGRyV/q1bqFQuJqJHc0U4Gn4=";
        };
        "x86_64-linux" = {
          url = "https://github.com/razein97/Wizql-Issue-Tracker/releases/download/${version}/WizQl_${version}_amd64.deb";
          hash = "sha256-sapf4RX+BCG+IlPcW4gwrFFSF3hEI95RRyZCEshXb0g=";
        };
      };
    in
    sources."${stdenvNoCC.hostPlatform.system}"
  );

  strictDeps = true;

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    autoPatchelfHook
    dpkg
    makeBinaryWrapper
  ];

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    gtk
    libsoup
    webkitgtk
    xdotool
  ];

  buildPhase = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    runHook preBuild

    dpkg-deb --extract $src $out

    runHook postBuild
  '';

  postInstall =
    if stdenvNoCC.hostPlatform.isLinux then
      ''
        mv "$out"/usr/* "$out"
        rmdir "$out"/usr
        wrapProgram "$out"/bin/WizQl \
          --prefix PATH : ${lib.makeBinPath [ desktop-file-utils ]}
      ''
    else
      ''
        mkdir --parents "$out"/{Applications,bin}
        cp --recursive . "$out"/Applications/WizQl.app
        ln --symbolic \
          "$out"/Applications/WizQl.app/Contents/MacOS/WizQl \
          "$out"/bin/${finalAttrs.meta.mainProgram}
      '';

  meta = {
    description = "Your databases, Simplified";
    longDescription = ''
      The database client built for how developers actually
      work.  Query MongoDB with SQL, expose any database as an HTTP
      API, and work across every platform — one payment, no
      subscriptions.
    '';
    homepage = "https://wizql.com";
    license = lib.licenses.unfree;
    mainProgram = "WizQl";
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
