{ lib, stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "nordic";
  version = "unstable-2021-05-21";

  srcs = [
    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "7e4f95ddaa8d94a66ed11a3b939cbd10864f1610";
      sha256 = "079gf8gxn1d2j44nhx4jzx2hz8hpsid7xwh414fjl3g2avb7n05a";
      name = "Nordic";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "0b4197e281ba306ac4918cabbd83003c38c0067d";
      sha256 = "1w85i2fbils2ivwsa85g1asj2nx0p0cak840nyr58hdwky49ci5p";
      name = "Nordic-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "aba3c78910de8a47950a0b2defb8022c615d91f6";
      sha256 = "1746w0iahmdgw3kj1q2cswf12pf0ln7qq1grfz9sn8rjafzjchj8";
      name = "Nordic-darker";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "9946dd747e1ea05782e084d2c2d94e2e4c7605ac";
      sha256 = "0mz1l1h26zhv0pnsbs0rx0xrwrn2y8g3ik0aa8ww5f411vvzgfr5";
      name = "Nordic-darker-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "5c0be5a783cd14af5c7647ca13d946c64e03561d";
      sha256 = "0751z3b9s0ycrsha20jx8lhdgvggcl0rdgv975dpaiqqjqyd9z06";
      name = "Nordic-bluish-accent";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "9cb8d9f786614579e59ec2c3dd9fd8dd9b56316e";
      sha256 = "09s9y7waygrx3p6c0c4py0ywg2ihpdmx73xhw5f92rr5nhsvish7";
      name = "Nordic-bluish-accent-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "69652db56e1721ac183cd57d21a801a09655a811";
      sha256 = "0zjd4np11mjwmc1kh2n1ig77g4wq88s2yrmnga0gvw1lf44n3qn2";
      name = "Nordic-Polar";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "3a67c1a2308ba3e9ec5d82f4a3416f85b6085b08";
      sha256 = "0gpg2izh4ay78j79vjp4svmi3qy9qaw0n6ai8zwm7p25dwm56fjy";
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
    rm -r $out/share/themes/*/kde
    rm -r $out/share/themes/*/xfwm4/{assets,render_assets.fish}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Gtk themes using the Nord color pallete";
    homepage = "https://github.com/EliverLara/Nordic";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
