{ lib
, makeDesktopItem
, copyDesktopItems
, wrapGAppsHook
, glib
, gnome
, mkCoqDerivation
, coq
, version ? null }:

with lib; mkCoqDerivation rec {
  pname = "coqide";
  inherit version;

  inherit (coq) src;
  release."${coq.version}" = {};

  defaultVersion = if versions.isGe "8.14" coq.version then coq.version else null;

  preConfigure = ''
    patchShebangs dev/tools/
  '';
  prefixKey = "-prefix ";

  useDune2 = true;

  buildInputs = [
    copyDesktopItems
    wrapGAppsHook
    coq.ocamlPackages.lablgtk3-sourceview3
    glib
    gnome.adwaita-icon-theme
  ];

  buildPhase = ''
    runHook preBuild
    dune build -p ${pname} -j $NIX_BUILD_CORES
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    dune install --prefix $out ${pname}
    runHook postInstall
  '';

  desktopItems = makeDesktopItem {
    name = "coqide";
    exec = "coqide";
    icon = "coq";
    desktopName = "CoqIDE";
    comment = "Graphical interface for the Coq proof assistant";
    categories = [ "Development" "Science" "Math" "IDE" "GTK" ];
  };

  meta = with lib; {
    homepage = "https://coq.inria.fr";
    description = "The CoqIDE user interface for the Coq proof assistant";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.Zimmi48 ];
  };
}
