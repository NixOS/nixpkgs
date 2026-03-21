{
  autoPatchelfHook,
  desktop-file-utils,
  dpkg,
  fetchurl,
  glib-networking,
  gtk3,
  lib,
  libsoup_3,
  stdenvNoCC,
  webkitgtk_4_1,
  wrapGAppsHook3,
  xdg-utils,
  xdotool,
}:

stdenvNoCC.mkDerivation (
  finalAttrs:
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
  {
    pname = "wizql";
    version = "1.7.2";

    src = fetchurl (
      sources.${stdenvNoCC.hostPlatform.system}
        or (throw "wizql: unsupported system ${stdenvNoCC.hostPlatform.system}")
    );

    strictDeps = true;
    __structuredAttrs = true;

    nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
      autoPatchelfHook
      dpkg
      wrapGAppsHook3
    ];

    buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
      glib-networking
      gtk3
      libsoup_3
      webkitgtk_4_1
      xdotool
    ];

    installPhase =
      if stdenvNoCC.hostPlatform.isLinux then
        ''
          runHook preInstall

          cp --recursive usr "$out"
          # Upstream links against libxdo.so.3, but xdotool 4 bumped the
          # soname.  The libxdo functions WizQl uses (xdo_new, xdo_free and
          # xdo_send_keysequence_window) have unchanged signatures.
          patchelf --replace-needed libxdo.so.3 libxdo.so.4 "$out"/bin/WizQl

          runHook postInstall
        ''
      else
        ''
          runHook preInstall

          mkdir --parents "$out"/{Applications,bin}
          cp --recursive . "$out"/Applications/WizQl.app
          ln --symbolic \
            "$out"/Applications/WizQl.app/Contents/MacOS/WizQl \
            "$out"/bin/${finalAttrs.meta.mainProgram}

          runHook postInstall
        '';

    # The deep-link plugin runs update-desktop-database and xdg-mime on every
    # start and aborts the startup if either command is missing.
    preFixup = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
      gappsWrapperArgs+=(
        --prefix PATH : ${
          lib.makeBinPath [
            desktop-file-utils
            xdg-utils
          ]
        }
      )
    '';

    passthru.updateScript = ./update.sh;

    meta = {
      description = "Database client for PostgreSQL, MySQL, SQLite, MongoDB, DuckDB and more";
      longDescription = ''
        WizQl is a proprietary database client.  It queries MongoDB with
        SQL, exposes databases as HTTP APIs, and supports PostgreSQL,
        MySQL, SQLite, SQLCipher, MongoDB, DuckDB, LibSQL and IBM Db2.
      '';
      homepage = "https://wizql.com";
      changelog = "https://github.com/razein97/Wizql-Issue-Tracker/releases/tag/${finalAttrs.version}";
      license = lib.licenses.unfree;
      mainProgram = "WizQl";
      maintainers = with lib.maintainers; [ yiyu ];
      platforms = lib.attrNames sources;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  }
)
