{ lib, stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "nordic";
  version = "unstable-2021-08-13";

  srcs = [
    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "937ca200e8148a61c73228030ec260abecc27fb2";
      sha256 = "0h7z7jh5p0916i9lx4n94r6vbydafnikdi6d9p4djvpyhn5nizgy";
      name = "Nordic";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "e736846a130be7907e977b16d0b3a0ab19631015";
      sha256 = "0dv7z31zw1r3iac5bvwapf9lm99y5l0xfzaw93hn8msh10w5crx8";
      name = "Nordic-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "8ff12077f28e25f4e57f055a51e5e3b9b1bf53fd";
      sha256 = "082k0na39qb97kbvc15g3mdfh8d8ricql84i4wdjy3rjfbfwq0pl";
      name = "Nordic-darker";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "8c422e4bfdf5680ff323938f49f411680154d3d6";
      sha256 = "1w540zlmsxpwa455wpxy1dpgv2fjr36xwjqbyc8x4y0ya0qfify0";
      name = "Nordic-darker-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "ce31d794fe1c6b72d3cff2e9513e08ddce014118";
      sha256 = "09d41wllr9hgxshgvpgngx9rlg8pvx5aqgkk5q8jra4jz2a92fhq";
      name = "Nordic-bluish-accent";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "8ca4fe244c31775effacc77f0a25ae10c6bee60c";
      sha256 = "1cby8wmaqdqpd9c40wiy7i9wmrazwfhb3h818hg0ni7yfcm2fr58";
      name = "Nordic-bluish-accent-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "a2d1c633ac2bfe261e8f612c8af14af0311c7f67";
      sha256 = "05llvix671i6128vbr3jiik8mipaab7bn0v9i89ydwyfhw822n7v";
      name = "Nordic-Polar";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "62a1702a17e7ea96e9b692832d68a0a7f26aabb6";
      sha256 = "0r1qn1rj322b44h15hcfbx79hhmb1m4pkv2fpdsn3s2klcxwr1ql";
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
