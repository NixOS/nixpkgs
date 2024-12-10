{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk-engine-murrine,
}:

stdenvNoCC.mkDerivation {
  pname = "andromeda-gtk-theme";
  version = "0-unstable-2024-03-04";

  srcs = [
    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "Andromeda-gtk";
      rev = "250751a546dd0fa2e67eef86d957fbf993b61dfe";
      hash = "sha256-exr9j/jW2P9cBhKUPQy3AtK5Vgav5vOyWInXUyVhBk0=";
      name = "Andromeda";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "Andromeda-gtk";
      rev = "11a6194d19cb846447db048455a5e782ec830ae1";
      hash = "sha256-Yy3mih0nyA+ahLqj2D99EKqtmWYJRsvQMkmlLfUPcqQ=";
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
    description = "An elegant dark theme for gnome, mate, budgie, cinnamon, xfce";
    homepage = "https://github.com/EliverLara/Andromeda-gtk";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jakedevs ];
  };
}
