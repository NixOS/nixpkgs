{ lib
, stdenv
, fetchFromGitHub
, gtk-engine-murrine
, jdupes
}:

stdenv.mkDerivation rec {
  pname = "nordic";
  version = "unstable-2022-01-08";

  srcs = [
    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "85086324c2a8fa7ca538b85ad0681e03733b2c86";
      sha256 = "sha256-p1nr71iJZm+2123WF67NkunBX2dR4ruK2Afqd7XdeGc=";
      name = "Nordic";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "46c9e6665963ccb54938d7730e520bd8c52f4307";
      sha256 = "sha256-uFnNLshyKOvzaij7tEKb0fw0j3/GGfzznAf/aaKx7XI=";
      name = "Nordic-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "da5c930386427fce65ea185f164709c8a20e362f";
      sha256 = "sha256-Ee9ymuMWs2ZgU+8FVLaviGtHMT4Sz5NWLaEGln2Z4V0=";
      name = "Nordic-darker";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "fd85fb2712ac1192e35c92149b75bfc3c440b1c7";
      sha256 = "sha256-6WUQBeNq7EKNkYcCt/fUYloue90gxfp8bDYawkQQ6ss=";
      name = "Nordic-darker-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "259e30ce13566214c7594b038dd2c240648a07a0";
      sha256 = "sha256-F6hC6XbT9yJl6SW9qJNlwmmBcvOrOS5yPCQALZFhgbM=";
      name = "Nordic-bluish-accent";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "2a27051d87558dfa595fb94eff34241d3a1b8c30";
      sha256 = "sha256-JIld6GVtr1tz02Do2Ft92qtza6iGrPapasd6jmMFG6k=";
      name = "Nordic-bluish-accent-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "0bea76aed39bb2a2669278b8403c4129aa47be0f";
      sha256 = "sha256-OXmz6uHXh1zl93sgv5WEwARkEUCr4PRh0/mJyMLXpnk=";
      name = "Nordic-Polar";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "8fe52b6c276a7e548e87a558db6734cf9f003b06";
      sha256 = "sha256-/IxlBvMLAK+mGRyaa7bTv/oZS24nSNeE5GsyJIeN6UU=";
      name = "Nordic-Polar-standard-buttons";
    })
  ];

  sourceRoot = ".";

  nativeBuildInputs = [ jdupes ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    cp -a Nordic* $out/share/themes
    rm -r $out/share/themes/*/.gitignore
    rm -r $out/share/themes/*/Art
    rm -r $out/share/themes/*/LICENSE
    rm -r $out/share/themes/*/README.md
    rm -r $out/share/themes/*/{package.json,package-lock.json,Gulpfile.js}
    rm -r $out/share/themes/*/src
    rm -r $out/share/themes/*/cinnamon/*.scss
    rm -r $out/share/themes/*/gnome-shell/{extensions,*.scss}
    rm -r $out/share/themes/*/gtk-2.0/{assets.svg,assets.txt,links.fish,render-assets.sh}
    rm -r $out/share/themes/*/gtk-3.0/{apps,widgets,*.scss}
    rm -r $out/share/themes/*/xfwm4/{assets,render_assets.fish}

    # move kde related contents to appropriate directories
    mkdir -p $out/share/{aurorae/themes,color-schemes,Kvantum,plasma,sddm/themes/Nordic}
    mv -v $out/share/themes/Nordic/kde/aurorae/* $out/share/aurorae/themes/
    mv -v $out/share/themes/Nordic/kde/colorschemes/* $out/share/color-schemes/
    mv -v $out/share/themes/Nordic/kde/konsole $out/share/
    mv -v $out/share/themes/Nordic/kde/kvantum/* $out/share/Kvantum/
    mv -v $out/share/themes/Nordic/kde/plasma/look-and-feel $out/share/plasma/
    mv -v $out/share/themes/Nordic/kde/sddm/* $out/share/sddm/themes/Nordic/
    rm -rf $out/share/themes/Nordic/kde

    # Replace duplicate files with hardlinks to the first file in each
    # set of duplicates, reducing the installed size in about 65%
    jdupes -L -r $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "Gtk and KDE themes using the Nord color pallete";
    homepage = "https://github.com/EliverLara/Nordic";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
