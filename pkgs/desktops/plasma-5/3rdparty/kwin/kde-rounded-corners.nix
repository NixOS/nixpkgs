{ pkgs, qtbase, qttools, qtx11extras, kconfig, kcoreaddons, ki18n,
kio, kglobalaccel, kinit, kwin, xorg, libepoxy, lib }:

{
  kde-rounded-corner = pkgs.stdenv.mkDerivation {
    pname = "kde-rounded-corners";
    version = "2021-11-06";

    src = pkgs.fetchFromGitHub {
      owner = "matinlotfali";
      repo = "KDE-Rounded-Corners";
      rev = "8ad8f5f5eff9d1625abc57cb24dc484d51f0e1bd";
      sha256 = "sha256-N6DBsmHGTmLTKNxqgg7bn06BmLM2fLdtFG2AJo+benU=";
    };

    dontWrapQtApps = true;

    prePatch = ''
      substituteInPlace CMakeLists.txt \
        --replace $\{MODULEPATH} "$out/lib/qt-${qtbase.version}/plugins" \
        --replace $\{DATAPATH} "$out/share"
    '';
    #for some reason, settings these in value in CMakeFlags doesn't work

    nativeBuildInputs = [ pkgs.cmake pkgs.extra-cmake-modules ];

    buildInputs = [
      qtbase
      qttools
      qtx11extras
      kconfig
      kcoreaddons
      ki18n
      kio
      kglobalaccel
      kinit
      kwin
      xorg.libXdmcp
      libepoxy
    ];

    meta = with lib; {
      description = "Kwin effect making have rounded corners";
      homepage = "https://github.com/matinlotfali/KDE-Rounded-Corners";
      license = licenses.gpl3;
      maintainers = [ maintainers.marius851000 ];
    };
  };
}
