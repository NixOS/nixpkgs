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
  version = "1.7.2";

  src = fetchurl (
    let
      sources = {
        "aarch64-darwin" = {
          url = "https://github.com/razein97/Wizql-Issue-Tracker/releases/download/${finalAttrs.version}/WizQl_${finalAttrs.version}_aarch64.app.tar.gz";
          hash = "sha256-z4szcm1/n3LeN0FAJ/o7JyjEMq0SaMKZYx6OC5YCAvw=";
        };
        "aarch64-linux" = {
          url = "https://github.com/razein97/Wizql-Issue-Tracker/releases/download/${finalAttrs.version}/WizQl_${finalAttrs.version}_arm64.deb";
          hash = "sha256-8NjACvJtjpwN5YgmlUzv9KiZnLsmPCDNSZGmlPhveDQ=";
        };
        "x86_64-linux" = {
          url = "https://github.com/razein97/Wizql-Issue-Tracker/releases/download/${finalAttrs.version}/WizQl_${finalAttrs.version}_amd64.deb";
          hash = "sha256-iLs9iRZAUzGaYNAK9IP5HrrwRYZfDnxKhP4Q+0Ov30I=";
        };
      };
    in
    sources."${stdenvNoCC.hostPlatform.system}"
  );

  strictDeps = true;
  __structuredAttrs = true;

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
        # Upstream links against libxdo.so.3, but xdotool 4 bumped the
        # soname.  The libxdo functions WizQl uses (xdo_new, xdo_free and
        # xdo_send_keysequence_window) have unchanged signatures.
        patchelf --replace-needed libxdo.so.3 libxdo.so.4 "$out"/bin/WizQl
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
      "aarch64-linux"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
