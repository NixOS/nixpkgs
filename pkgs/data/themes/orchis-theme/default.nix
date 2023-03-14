{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, gnome-themes-extra
, gtk-engine-murrine
, sassc
, border-radius ? null # Suggested: 2 < value < 16
, tweaks ? [ ] # can be "solid" "compact" "black" "primary" "macos" "submenu" "nord|dracula"
, withWallpapers ? false
}:

let
  pname = "orchis-theme";

  validTweaks = [ "solid" "compact" "black" "primary" "macos" "submenu" "nord" "dracula" ];

  nordXorDracula = with builtins; lib.assertMsg (!(elem "nord" tweaks) || !(elem "dracula" tweaks)) ''
    ${pname}: dracula and nord cannot be mixed. Tweaks ${toString tweaks}
  '';
in

assert nordXorDracula;
lib.checkListOfEnum "${pname}: theme tweaks" validTweaks tweaks

stdenvNoCC.mkDerivation
rec {
  inherit pname;
  version = "2023-02-26";

  src = fetchFromGitHub {
    repo = "Orchis-theme";
    owner = "vinceliuice";
    rev = version;
    sha256 = "sha256-Qk5MK8S8rIcwO7Kmze6eAl5qcwnrGsiWbn0WNIPjRnA=";
  };

  nativeBuildInputs = [ gtk3 sassc ];

  buildInputs = [ gnome-themes-extra ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  preInstall = ''
    mkdir -p $out/share/themes
  '';

  installPhase = ''
    runHook preInstall
    bash install.sh -d $out/share/themes -t all \
      ${lib.optionalString (tweaks != []) "--tweaks " + builtins.toString tweaks} \
      ${lib.optionalString (!isNull border-radius) ("--round " + builtins.toString border-radius + "px")}
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
