{ lib, stdenvNoCC, fetchFromGitHub, gtk-engine-murrine }:

stdenvNoCC.mkDerivation {
  pname = "andromeda-gtk-theme";
  version = "0-unstable-2024-06-08";

  srcs = [
    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "Andromeda-gtk";
      rev = "8efb8ffef7118adf7a22d34a287594499d62b9b8";
      hash = "sha256-AlPSD6tPNYY8iqPFS5IVOO5Zd3UqR3uS5h4l48UZ+dw=";
      name = "Andromeda";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "Andromeda-gtk";
      rev = "b8c1a8bd0ba8d3e35dcd43f3fc3c177844b02c9c";
      hash = "sha256-51IWJtbAHA8jNbrGbudiwqQ9SC4dpj9CTHqovNWOtc8=";
      name = "Andromeda-standard-buttons";
    })
  ];

  sourceRoot = ".";

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    cp -a Andromeda* $out/share/themes

    # remove uneeded files, which are not distributed in https://www.gnome-look.org/p/2039961/
    rm -rf $out/share/themes/*/.gitignore
    rm -rf $out/share/themes/*/Art
    rm -rf $out/share/themes/*/LICENSE
    rm -rf $out/share/themes/*/README.md
    rm -rf $out/share/themes/*/{package.json,package-lock.json,Gulpfile.js}
    rm -rf $out/share/themes/*/src
    rm -rf $out/share/themes/*/cinnamon/*.scss
    rm -rf $out/share/themes/*/gnome-shell/{earlier-versions,extensions,*.scss}
    rm -rf $out/share/themes/*/gtk-2.0/{assets.svg,assets.txt,links.fish,render-assets.sh}
    rm -rf $out/share/themes/*/gtk-3.0/{apps,widgets,*.scss}
    rm -rf $out/share/themes/*/gtk-4.0/{apps,widgets,*.scss}
    rm -rf $out/share/themes/*/xfwm4/{assets,render_assets.fish}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Elegant dark theme for gnome, mate, budgie, cinnamon, xfce";
    homepage = "https://github.com/EliverLara/Andromeda-gtk";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jakedevs ];
  };
}
