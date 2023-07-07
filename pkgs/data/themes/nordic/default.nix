{ lib
, stdenv
, fetchFromGitHub
, gtk-engine-murrine
, jdupes
}:

stdenv.mkDerivation rec {
  pname = "nordic";
  version = "unstable-2023-05-12";

  srcs = [
    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "399246cdcbdb1a714c5bb294857cd5a6494b6006";
      sha256 = "sha256-0yZ4QYcdcGHEw6tdcXAKZ4e+mhNNmvihBxp2sLgTuu8=";
      name = "Nordic";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "3599ddb6f8b7de936cf106bddd4f929ddfe88b1c";
      sha256 = "sha256-ft5UbBnjP0xNFFVwk5Elvrpcj273OupjM+MGJVlvJZQ=";
      name = "Nordic-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "b03b66d5badadc2e5ff27b8745a2308b8fafaa61";
      sha256 = "sha256-6dORsGfYi7q8z7JWA3Y9oqVs9bhT/gbdSrcgJcebGP8=";
      name = "Nordic-darker";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "e19b75f56e5c328352c183fc960a0be54e99836e";
      sha256 = "sha256-deKHT0dE5tsUo7+vkzxQ/eRon7COrOAWolw17VtKhiE=";
      name = "Nordic-darker-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "b134b4a1299b3c4a2d9543707ec2b5a0fc97987c";
      sha256 = "sha256-XSDwc0/59sUHkS0holvujmr/p6vX79648l9cxJqunuM=";
      name = "Nordic-bluish-accent";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "a4efbc09470b36f4cf6af60b5fdfeb8e09282fb3";
      sha256 = "sha256-Qgrl6p0AhbhK0+aM8hu85Kz/Lz/b2Nn8uWS+WpTGjU4=";
      name = "Nordic-bluish-accent-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "0d44fb16d0f07ef8615fd7740317a518d2b9411f";
      sha256 = "sha256-388251/Tg4jyn7c8zkrUxVFooN9O67xk2NTSeYa0VvI=";
      name = "Nordic-Polar";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "0eea9185946fee20b6d7472548226a3652dea7ae";
      sha256 = "sha256-8JFrmGKn8cl1x3TeDPee1zbMmtypJ9kALv/PRqRHGAU=";
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
