{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  breeze-icons,
  gtk-engine-murrine,
  jdupes,
  plasma-framework,
  plasma-workspace,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nordic";
  version = "2.2.0-unstable-2024-06-25";

  srcs = [
    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "8f7bcdb597778b7233c97423f19c936e6c5d4abf";
      hash = "sha256-fNPrBpdJS164DezKEnLixGUQxCW5RQ97Oj6BNI3Dr34=";
      name = "Nordic";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "ae071e635055e8401e120d652602a183110bb91d";
      hash = "sha256-YOfy2TNxq5FKB311C9t26WtrWefSdVdMNAq458BO5bQ=";
      name = "Nordic-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "07e62d14347ae233a857ed77b72d8c8e7a108a6e";
      hash = "sha256-7S+d9oQjewtVgIlr8OxCNU0OdZyoPNELtV6LtMhkoQ8=";
      name = "Nordic-darker";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "3a7a56656a50d65e85bea58c649088a5aaa30690";
      hash = "sha256-WYaFsGqBNf5K5uAqnC8I5o7NC7MRNqGFJ0hLkB24RxU=";
      name = "Nordic-darker-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "db4fd3af7e2af0ff962296b2881a94b14fa73e66";
      hash = "sha256-U6o99D62H2BIvUV/xHc+wtbIFDdxxPxQWu5/f8NWhQ0=";
      name = "Nordic-bluish-accent";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "f75e18799b804d17b97eead583548b9415faddb6";
      hash = "sha256-O0vad/gWUQ2B/2hz2uoSyRa1gM6N3ZbtOLyDJTNhIQo=";
      name = "Nordic-bluish-accent-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "9f109cad906cb47c188557b8f3d324dad394a008";
      hash = "sha256-+buFwFhk10qwsfS6DwUQzE0/F67BcoS+zXGk8wKn1Bc=";
      name = "Nordic-Polar";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "60f63d9d54d93bda0529b8a6fae32427d00ae73c";
      hash = "sha256-565iCxMX5Jms+nN0nRFp25YJ/sfKt13sAoIrEgoXGtg=";
      name = "Nordic-Polar-standard-buttons";
    })
  ];

  sourceRoot = ".";

  outputs = [
    "out"
    "sddm"
  ];

  nativeBuildInputs = [ jdupes ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    # install theme files
    mkdir -p $out/share/themes
    cp -a Nordic* $out/share/themes

    # remove uneeded files
    rm -r $out/share/themes/*/.gitignore
    rm -r $out/share/themes/*/Art
    rm -r $out/share/themes/*/FUNDING.yml
    rm -r $out/share/themes/*/LICENSE
    rm -r $out/share/themes/*/README.md
    rm -r $out/share/themes/*/{package.json,package-lock.json,Gulpfile.js}
    rm -r $out/share/themes/*/src
    rm -r $out/share/themes/*/cinnamon/*.scss
    rm -r $out/share/themes/*/gnome-shell/{earlier-versions,extensions,*.scss}
    rm -r $out/share/themes/*/gtk-2.0/{assets.svg,assets.txt,links.fish,render-assets.sh}
    rm -r $out/share/themes/*/gtk-3.0/{apps,widgets,*.scss}
    rm -r $out/share/themes/*/gtk-4.0/{apps,widgets,*.scss}
    rm -r $out/share/themes/*/xfwm4/{assets,render_assets.fish}

    # move wallpapers to appropriate directory
    mkdir -p $out/share/wallpapers/Nordic
    mv -v $out/share/themes/Nordic/extras/wallpapers/* $out/share/wallpapers/Nordic/
    rmdir $out/share/themes/Nordic/extras{/wallpapers,}

    # move kde related contents to appropriate directories
    mkdir -p $out/share/{aurorae/themes,color-schemes,Kvantum,plasma,icons}
    mv -v $out/share/themes/Nordic/kde/aurorae/* $out/share/aurorae/themes/
    mv -v $out/share/themes/Nordic/kde/colorschemes/* $out/share/color-schemes/
    mv -v $out/share/themes/Nordic/kde/konsole $out/share/
    mv -v $out/share/themes/Nordic/kde/kvantum/* $out/share/Kvantum/
    cp -vr $out/share/themes/Nordic/kde/plasma/look-and-feel $out/share/plasma/look-and-feel/
    mv -v $out/share/themes/Nordic/kde/plasma/look-and-feel $out/share/plasma/desktoptheme/
    mv -v $out/share/themes/Nordic/kde/folders/* $out/share/icons/
    mv -v $out/share/themes/Nordic/kde/cursors/*-cursors $out/share/icons/

    rm -rf $out/share/plasma/look-and-feel/*/contents/{logout,osd,components}
    rm -rf $out/share/plasma/desktoptheme/*/contents/{{defaults,splash,previews}

    mkdir -p $sddm/share/sddm/themes
    mv -v $out/share/themes/Nordic/kde/sddm/* $sddm/share/sddm/themes/

    rm -rf $out/share/themes/Nordic/kde

    # Replace duplicate files with symbolic links to the first file in
    # each set of duplicates, reducing the installed size in about 53%
    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  postFixup = ''
    # Propagate sddm theme dependencies to user env otherwise sddm
    # does not find them. Putting them in buildInputs is not enough.

    mkdir -p $sddm/nix-support

    printWords ${breeze-icons} ${plasma-framework} ${plasma-workspace} \
      >> $sddm/nix-support/propagated-user-env-packages
  '';

  meta = {
    description = "Gtk and KDE themes using the Nord color pallete";
    homepage = "https://github.com/EliverLara/Nordic";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.romildo ];
  };
}
