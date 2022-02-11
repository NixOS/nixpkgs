{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, gnome-themes-extra
, gtk-engine-murrine
, sassc
, tweaks ? [ ] # can be "solid" "compact" "black" "primary"
, withWallpapers ? false
}:

let
  validTweaks = [ "solid" "compact" "black" "primary" ];
  unknownTweaks = lib.subtractLists validTweaks tweaks;
in
assert lib.assertMsg (unknownTweaks == [ ]) ''
  You entered wrong tweaks: ${toString unknownTweaks}
  Valid tweaks are: ${toString validTweaks}
'';

stdenvNoCC.mkDerivation
rec {
  pname = "orchis-theme";
  version = "2021-12-13";

  src = fetchFromGitHub {
    repo = "Orchis-theme";
    owner = "vinceliuice";
    rev = version;
    sha256 = "sha256-PN2ucGMDzRv4v86X1zVIs9+GkbMWuja2WaSQLFvJYd0=";
  };

  nativeBuildInputs = [ gtk3 sassc ];

  buildInputs = [ gnome-themes-extra ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  preInstall = ''
    mkdir -p $out/share/themes
  '';

  installPhase = ''
    runHook preInstall
    bash install.sh -d $out/share/themes -t all ${lib.optionalString (tweaks != []) "--tweaks " + builtins.toString tweaks}
    ${lib.optionalString withWallpapers ''
      mkdir -p $out/share/backgrounds
      cp src/wallpaper/{1080p,2k,4k}.jpg $out/share/backgrounds
    ''}
    runHook postInstall
  '';

  meta = with lib; {
    description = "A Material Design theme for GNOME/GTK based desktop environments.";
    homepage = "https://github.com/vinceliuice/Orchis-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.fufexan ];
  };
}
