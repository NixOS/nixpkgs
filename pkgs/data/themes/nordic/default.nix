{ lib, stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "nordic";
  version = "2.1.0";

  srcs = [
    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "0112af91943b8819f7a1af9a508cda7fe3d74051";
      sha256 = "sha256-ccOA5/jXTx20495NpTgVu7DvsjfTEULqL3IyJ+Pd/ug";
      name = "Nordic";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "b30d2c844cc6ef5d020308f1c02791de45b607a7";
      sha256 = "sha256-g5yCCFXzipZLmUat+1r6QWHB7DWQvMKhMexHPV/DJHM";
      name = "Nordic-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "6d38d6af363528f42619f663e3ecd4c08dfd2411";
      sha256 = "sha256-jaRiSE6yfTltzZ2vr8w4d+YtSz7REOcL7vOOhQvIMlQ";
      name = "Nordic-darker";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "4142817c14c27b371d42796445bedc84dc94672c";
      sha256 = "sha256-FAb1+EREcwYrfSxAl6LrPaJtkHMt67NV3bG87g1cFT4";
      name = "Nordic-darker-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "2a91d6f3db70412b0a80ed33546fbe93075627d8";
      sha256 = "sha256-Su+amS7moc2IDONNvqw3bjL6Q0WLJWzHu6WvfcVDcDY";
      name = "Nordic-bluish-accent";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "3ebd334f97d638fdc888b16d69851e3ee31131f2";
      sha256 = "sha256-h0IXtWcdDvAEVi/1cLZF4Vacdl6VAY+5uo0LGPNe0bg";
      name = "Nordic-bluish-accent-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "803926882f8178c72b433466a377aaa33c5b372a";
      sha256 = "sha256-G7Vu03PoFOEU9uxb5JiHR4Tr8qk47fPo7Gg7Vt9Zzns";
      name = "Nordic-Polar";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "988cb8a16ece3901b8b0e7a5b86503400491cb1e";
      sha256 = "sha256-Zx1mrzJm5o4wQwOR8ZU2OEcjD3/6UXwLrBYpMtCkQbg";
      name = "Nordic-Polar-standard-buttons";
    })
  ];

  sourceRoot = ".";

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
