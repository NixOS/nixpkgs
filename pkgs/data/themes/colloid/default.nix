{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, gnome-themes-extra
, gtk-engine-murrine
, sassc
, tweaks ? [ ] 
, jdupes
, bash
}:
let
  validTweaks = [ "compact" "nord" "rimless" "normal" "dracula" ];
  unknownTweaks = lib.subtractLists validTweaks tweaks;
in
  assert lib.assertMsg (unknownTweaks == [ ]) ''
    You entered wrong tweaks: ${toString unknownTweaks}
    Valid tweaks are: ${toString validTweaks}
  '';

  stdenvNoCC.mkDerivation rec {
    pname = "Colloid-gtk-theme";
    version = "2022-05-15";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = pname;
      rev = "2c674203ab19776dd8b8dd74d88e239d89fbcf61";
      sha256 = "pdc5lRFT3xiLCGLxhBXTUGkbqEqr5/e3nrQrlx2qIOg=";
      name = "pname";
      };

  nativeBuildInputs = [ jdupes sassc ];
  buildInputs = [ bash gnome-themes-extra ];
  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  preInstall = ''
    mkdir -p $out/share/themes
    patchShebangs ./install.sh ./gtkrc.sh ./build.sh ./clean-old-theme.sh
  '';

  installPhase = ''
    runHook preInstall
    HOME=./tmp
    bash install.sh -d $out/share/themes -t all ${lib.optionalString (tweaks != []) "--tweaks " + builtins.toString tweaks}
    runHook postInstall
  '';

  postInstall = ''
    jdupes -L -r $out/share
    rm -rf ./tmp
  '';

  meta = with lib; {
    description = "Gtk MacOS and Nord inspired gtk theme";
    homepage = "https://github.com/vinceliuice/Colloid-gtk-theme";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ cirkku ];
  };
}
