{
  lib,
  buildGoModule,
  wine64Packages,
  fetchpatch,
  fetchFromGitHub,
  glib,
  makeBinaryWrapper,
  pkg-config,
  cairo,
  gdk-pixbuf,
  graphene,
  gtk4,
  libadwaita,
  libGL,
  libxkbcommon,
  pango,
  vulkan-headers,
  vulkan-loader,
  wayland,
  winetricks,
  xorg,
  symlinkJoin,
  nix-update-script,
}:
let
  wine =
    (wine64Packages.staging.override {
      dbusSupport = true;
      embedInstallers = true;
      pulseaudioSupport = true;
      x11Support = true;
      waylandSupport = true;
    }).overrideAttrs
      (oldAttrs: {
        # https://github.com/flathub/org.vinegarhq.Vinegar/blob/a3c2f1249dec9548bd870027f55edcc58343b685/wine.yml#L31-L38
        # --with-wayland is added by waylandSupport = true;
        configureFlags = oldAttrs.configureFlags or [ ] ++ [
          "--disable-tests"
          "--disable-win16"
          "--with-dbus"
          "--with-pulse"
          "--with-x"
          "--without-oss"
        ];

        patches = oldAttrs.patches or [ ] ++ [
          (fetchpatch {
            name = "loader-prefer-winedllpath.patch";
            url = "https://raw.githubusercontent.com/flathub/org.vinegarhq.Vinegar/3e07606350d803fa386eb4c358836a230819380d/patches/wine/loader-prefer-winedllpath.patch";
            hash = "sha256-89wnr2rIbyw490hHwckB9g1GKCXm6BERnplfwEUlNOg=";
          })
        ];

        postInstall = ''
          cp $out/bin/wine $out/bin/wine64
        '';
      });
in
buildGoModule (finalAttrs: {
  pname = "vinegar";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "vinegarhq";
    repo = "vinegar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7rc6LKZx0OOZDedtTpHIQT4grx1FejRiVnJnVDUddy4=";
  };

  vendorHash = "sha256-TZhdwHom4DTgLs4z/eADeoKakMtyFrvVljDg4JJp7dc=";

  nativeBuildInputs = [
    glib
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib.out
    graphene
    gtk4
    libadwaita
    libGL
    libxkbcommon
    pango.out
    vulkan-headers
    vulkan-loader
    wayland
    wine
    winetricks
    xorg.libX11
    xorg.libXcursor
    xorg.libXfixes
  ];

  postPatch = ''
    substituteInPlace Makefile --replace-fail 'gtk-update-icon-cache' '${lib.getExe' gtk4 "gtk4-update-icon-cache"}'
  '';

  buildPhase = ''
    runHook preBuild

    make PREFIX=$out

    runHook postBuild
  '';

  # Add getGoDirs to checkPhase since it is not being provided by the buildPhase
  preCheck = ''
    getGoDirs() {
      local type;
      type="$1"
      if [ -n "$subPackages" ]; then
        echo "$subPackages" | sed "s,\(^\| \),\1./,g"
      else
        find . -type f -name \*$type.go -exec dirname {} \; | grep -v "/vendor/" | sort --unique | grep -v "$exclude"
      fi
    }
  '';

  installPhase = ''
    runHook preInstall

    make PREFIX=$out install

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/vinegar \
      --prefix PATH : ${
        lib.makeBinPath [
          wine
          winetricks
        ]
      } \
      --set-default PUREGOTK_LIB_FOLDER ${finalAttrs.passthru.libraryPath}/lib
  '';

  passthru = {
    libraryPath = symlinkJoin {
      name = "vinegar-puregotk-lib-folder";
      paths = [
        cairo
        gdk-pixbuf
        glib.out
        graphene
        gtk4
        libadwaita
        pango.out
        vulkan-loader
      ];
    };

    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/vinegarhq/vinegar/releases/tag/v${finalAttrs.version}";
    description = "Open-source, minimal, configurable, fast bootstrapper for running Roblox Studio on Linux";
    homepage = "https://github.com/vinegarhq/vinegar";
    license = lib.licenses.gpl3Only;
    mainProgram = "vinegar";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
