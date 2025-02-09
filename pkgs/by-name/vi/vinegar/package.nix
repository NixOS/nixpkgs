{
  lib,
  buildGoModule,
  wine64Packages,
  fetchpatch,
  fetchFromGitHub,
  glib,
  makeBinaryWrapper,
  pkg-config,
  gtk4,
  libadwaita,
  libGL,
  libxkbcommon,
  vulkan-headers,
  vulkan-loader,
  wayland,
  winetricks,
  xorg,
  symlinkJoin,
  cairo,
  gdk-pixbuf,
  graphene,
  pango,
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
        # https://github.com/flathub/org.vinegarhq.Vinegar/blob/1a42384ff0c5670504415190301c20e89601bbad/wine.yml#L31
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
      });
in
buildGoModule rec {
  pname = "vinegar";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "vinegarhq";
    repo = "vinegar";
    tag = "v${version}";
    hash = "sha256-eAQ5qlBY1PmpijEu7mPmCBFbAIA30ABcbirdBljAmTQ=";
  };

  vendorHash = "sha256-NLNAUf99psBq8PayorBH1DT6o9wZyKwx9ab+TtpKU50=";

  nativeBuildInputs = [
    glib
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    gtk4
    libadwaita
    libGL
    libxkbcommon
    vulkan-headers
    vulkan-loader
    wayland
    wine
    winetricks
    xorg.libX11
    xorg.libXcursor
    xorg.libXfixes
  ];

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

  preInstall = ''
    substituteInPlace Makefile --replace-fail 'gtk-update-icon-cache' '${lib.getExe' gtk4 "gtk4-update-icon-cache"}'
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
      --prefix PUREGOTK_LIB_FOLDER : ${passthru.libraryPath}/lib
  '';

  passthru = {
    libraryPath = symlinkJoin {
      name = "vinegar-puregotk-lib-folder";
      paths = [
        cairo
        glib.out
        graphene
        gdk-pixbuf
        gtk4
        libadwaita
        pango.out
        vulkan-loader
      ];
    };

    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/vinegarhq/vinegar/releases/tag/v${version}";
    description = "Open-source, minimal, configurable, fast bootstrapper for running Roblox Studio on Linux";
    homepage = "https://github.com/vinegarhq/vinegar";
    license = lib.licenses.gpl3Only;
    mainProgram = "vinegar";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
