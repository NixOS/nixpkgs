{ lib
, stdenv
, fetchFromGitHub
, gtk-engine-murrine
, jdupes
}:

stdenv.mkDerivation rec {
  pname = "nordic";
  version = "unstable-2022-02-26";

  srcs = [
    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "0da58e462e8ba6c71245d13fbddac950b72018ae";
      sha256 = "sha256-w7e3DqQV4L/OvntKHJA4+3Dj6dRnlH73SxvW770QIyU=";
      name = "Nordic";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "9daf11acf3419e2f23d0993ce862a1c944fb8519";
      sha256 = "sha256-zGgw6THLX7q19BDsllPUrWqQcL6FYAewcyqjQdXzLzg=";
      name = "Nordic-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "a40819bd00160f987cdf254ce8c34eabebecf0eb";
      sha256 = "sha256-rSNLdxTfvzTFzI5723WIGRS+NZ8iqUOUliDpkznZrwE=";
      name = "Nordic-darker";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "4e69cf6e1798938ab7c5795940c663d866ce8201";
      sha256 = "sha256-p8VaKeKxEiYX4oVqWoyschAq0j/LvPq9yD/awaHKRZw=";
      name = "Nordic-darker-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "866629583187b914725f05683125fde7f6c280f1";
      sha256 = "sha256-TQ4G5W87zpTrLU+f+eb5VHwaWuKSbItXCgXSL33U8As=";
      name = "Nordic-bluish-accent";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "f3702ae02e3caaf74eab0ef9156af9f2a476021b";
      sha256 = "sha256-drXRfZxCrH2vAXjZSAjWEHcQrehxnM0WLkgbh+cFJhI=";
      name = "Nordic-bluish-accent-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "4cf3e5c30ebd17a3d53ab0337c191e304feff7b5";
      sha256 = "sha256-LTCJ7AyABQDTDkjuqcXaKXePFwOpmXeKaW2mWYah4ao=";
      name = "Nordic-Polar";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "72cbd567212b21ea20769fe244c148f799435536";
      sha256 = "sha256-qNIyr+Eo0dzPVh9PxDCHv0e6pswACbf9nLhAG75YEYc=";
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
