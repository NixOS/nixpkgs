{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk-engine-murrine
, breeze-icons
, plasma-framework
, plasma-workspace
, jdupes
}:

stdenvNoCC.mkDerivation rec {
  pname = "nordic";
  version = "2.2.0-unstable-2024-05-24";

  srcs = [
    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "2f6b72b7b6d7112bb147a5adeca307631dd698cb";
      hash = "sha256-4GNEJTAS6EAPYyaNOZS1lGu67nobGmMOHoq8I5WaPcA=";
      name = "Nordic";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "d92b503cdabb4cf263de4c3fd9afba889c65aad1";
      hash = "sha256-foCWcKNdk9S1MijJOuw8jFV4gnDSNWmTjgSCU9GefzE=";
      name = "Nordic-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "b76c48252c9dc6171cccf63c0c412b9afe7fa89c";
      hash = "sha256-q/duyEin377J1cxD5+uXlEbPN/S27ht2es/02wKoiEY=";
      name = "Nordic-darker";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "b8b16b451bf5fcfada98a92682a6ff97d93fc36f";
      hash = "sha256-959P2xdpCLhNRedoakMiHXzj+H4SWX1Lb9w6yYRzGds=";
      name = "Nordic-darker-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "c45681eca7fce4c129063a0aae727d42b570fcfd";
      hash = "sha256-8a4pMkyGt+WIVXLSsLKbxCP9i4RdZKX5lvwZB+BemSY=";
      name = "Nordic-bluish-accent";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "b07b6450ff2389f88ef5ad980a1ead47071b1d63";
      hash = "sha256-+o46apK051UH6GbG/ugSgxI212MWEnYaVlDK9rWqPMU=";
      name = "Nordic-bluish-accent-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "bc3e7554ab8e8d94e978691054b1b062696eb688";
      hash = "sha256-tJX/oTEp/9pmzrINBWrnhS9n8JR40T1C0A4LhRLWU9A=";
      name = "Nordic-Polar";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "26b44080c2dbd1a9b576a24d1b14ae01b98519d0";
      hash = "sha256-5gGiBL7ZKFSPZtnikfrdvrWKG9RkIHdPyWdHYnmSTvg=";
      name = "Nordic-Polar-standard-buttons";
    })
  ];

  sourceRoot = ".";

  outputs = [ "out" "sddm" ];

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
