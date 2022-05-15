{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, gnome-themes-extra
, gtk-engine-murrine
, sassc
, tweaks ? [ ] 
, jdupes
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
      rev = "release_${version}";
      sha256 = "1fbj9c3n749na214b707xyh3ya9fw57q80g0xllgj36fgzy06h13";
      name = "pname";
      };

  nativeBuildInputs = [ jdupes sassc ];
  buildInputs = [ gnome-themes-extra ];
  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  preInstall = ''
    mkdir -p $out/share/themes
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
