{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk-engine-murrine,
  breeze-icons,
  plasma-framework,
  plasma-workspace,
  jdupes,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nordic";
  version = "2.2.0-unstable-2024-02-20";

  srcs = [
    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "58d5a8e10ae068b98a63e6de2791e289f417842d";
      hash = "sha256-Z3e7DoakK6f+UMBr78gZ+NJPb5vuJCfDgPRYywFDYeg=";
      name = "Nordic";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "cb7d95bd5438728f30f361a888dfb33b7f6ad28c";
      hash = "sha256-ZWGmDiXjEt0UuALyw7cjTYgdw9kdJJKc0vkclbZkBvo=";
      name = "Nordic-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "37b86a30ad3e048f87a689f2813aa28644035fa8";
      hash = "sha256-+O8+30H6humVQTwgFL3uQkeo5gPYrokpAKbT56PX6YQ=";
      name = "Nordic-darker";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "926b215d14394ff043f2d2969e730759af7acd86";
      hash = "sha256-yR0DfmUW1rr38Zbwtr7TUYL6z8vTNyoj0vEhphbZieU=";
      name = "Nordic-darker-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "1ae59d40ba8342fc14f3a55a2fb37446a8d10880";
      hash = "sha256-tFIXPP5Ohw8atNIqvMtB7sLka+/tw+aSbjMdzKfI9r0=";
      name = "Nordic-bluish-accent";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "aaaa5dab0517f182a85a75d457da70d22e577b26";
      hash = "sha256-J/nti2jxQ0VfTbp5WfrE0CN6Pvfg1edplL6/QPKUBzc=";
      name = "Nordic-bluish-accent-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "733d5ea57c6ecd8209ec0a928029e28b3f54f83d";
      hash = "sha256-y3ge0DF0SdKFjH+mZdHDpK3YG7Ng3rN0y0Er2WBC6Sc=";
      name = "Nordic-Polar";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "667dfe4f6e8157f30a4e0ea5dc1d17438520d6cf";
      hash = "sha256-p7bY1r8Ik+jsIyjR75UFHw8XuiGz5LmT09txBLyZpx4=";
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

  meta = with lib; {
    description = "Gtk and KDE themes using the Nord color pallete";
    homepage = "https://github.com/EliverLara/Nordic";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
