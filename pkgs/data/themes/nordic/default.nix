{ lib, stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "nordic";
  version = "unstable-2021-06-04";

  srcs = [
    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "9a98c05f4d4f6c9e701ac20b0bf5c18284ad0015";
      sha256 = "0ghgr7fr7anm8hdq6n46xhkjxydqkr0qlk1q7mdg08j43f0yra7b";
      name = "Nordic";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "90ce6f539735af1f231c4fa07708cef602e1c8a2";
      sha256 = "1g6sz7ifpc8jf4iplcsmihqhjdc7yp5xygw8584n122jmh8mak47";
      name = "Nordic-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "529cdb86b4d4474a67a56eb9377e3c7907b452db";
      sha256 = "06li44i5wh4h06fbhvjf5cjma5czjdgnwvm79d8hg6vmi2101b0a";
      name = "Nordic-darker";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "1d16f37de315c298a6c3d79a552ed6f18cbb7fb4";
      sha256 = "0nxzygnysg4ciib337vay0qcc80hpryjnclwjwjzj51i95366k25";
      name = "Nordic-darker-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "78a30080bc50ee88c23d393049306ef1925bcdb8";
      sha256 = "10w4815fcf3pd24ar7jp0wcdiwn3zzrdj2p6fqlgx26biz7kf3iv";
      name = "Nordic-bluish-accent";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "e4363da8d457e8b14f6e4340979225db92d34aa9";
      sha256 = "1sjw2hvg4jgxqzgqhqixq216a7vv5licbc8ii1rsz88ycafsbr7j";
      name = "Nordic-bluish-accent-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "a38fd7d440309573947d3e53ea3ed295cf027ce7";
      sha256 = "1r6hz0m0y7c1d0ka1x9cd47r0jvpgkld6x3gf2b7w7yvqpmh6a44";
      name = "Nordic-Polar";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "b86d43c48bcac57c49d891b967311fd90f6d4bcd";
      sha256 = "0c725kf5ql42zrqk6dwk6i7wyrhr3gddipvhy6692nv0dszqm0ml";
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
