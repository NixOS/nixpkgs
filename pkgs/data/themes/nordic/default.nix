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
  version = "2.2.0-unstable-2025-03-21";

  srcs = [
    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "0b5c46f3454ec8b8f3a8acd41993b92ee44e4a62";
      hash = "sha256-8BN1d/hsfkNWvdqsVyorRRZlj81/iAqJbONWIzy4iKw=";
      name = "Nordic";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "8713c00c38a9b5fe82199892edff7623033910a0";
      hash = "sha256-v3jQF2wN55/7CtQu2jYQU11RdPKzdEzoXjDebyLg518=";
      name = "Nordic-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "55f21590db56e9d68d95831cc1e98d9f08dcbf6b";
      hash = "sha256-tnXeS8VffzUgPTtGbTVEX7IGSoihqeCHtKO5+EuYxaE=";
      name = "Nordic-darker";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "8976bf0bd88b6604c6d88a504ef66537997e1167";
      hash = "sha256-uz/gPELRABT6PoHSihN3lC25KswaQt7xyVfm3Ux7F5U=";
      name = "Nordic-darker-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "d02b961b754c2b5144dbb5a4ac52fca149b44d5f";
      hash = "sha256-xncXYKfocuv6AOmG8XX1/ahcERYGRRU8d0b7zJmhz5Q=";
      name = "Nordic-bluish-accent";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "40c954e0134ad77113cec4d83e8381a55b735e34";
      hash = "sha256-qRL/o11bQ2RQgJq9nmrr+HFZKoEhASvxr1R4tra2BwA=";
      name = "Nordic-bluish-accent-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "6f32e3708355fbf9ac04342361134a2d45b4ce5d";
      hash = "sha256-j70j0WqGzzkvNTVrkg0Zz+wVrs3/JdPVO8gliUSXRnc=";
      name = "Nordic-Polar";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "ca23b9460713e72defae777162175921beae6e27";
      hash = "sha256-wkmmpviQBGoE/+/tPTIIgkWFUYtYney5Yz12m8Zlak8=";
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

  # FIXME: https://github.com/EliverLara/Nordic/issues/331
  dontCheckForBrokenSymlinks = true;

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
    rm -rf $out/share/plasma/desktoptheme/*/contents/{defaults,splash,previews}
    rm -rf $out/share/Kvantum/*.tar.xz

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
