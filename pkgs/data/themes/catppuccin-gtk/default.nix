{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, gnome-themes-extra
, gtk-engine-murrine
, sassc
, tweaks ? [ ]
, size ? "standard"
}:
let
  validSizes = [ "standard" "compact" ];
  validTweaks = [ "nord" "dracula" "black" "rimless" "normal" ];

  unknownTweaks = lib.subtractLists validTweaks tweaks;
  illegalMix = (lib.elem "nord" tweaks) && (lib.elem "dracula" tweaks);

  assertIllegal = lib.assertMsg (!illegalMix) ''
    Tweaks "nord" and "dracula" cannot be mixed. Tweaks: ${toString tweaks}
  '';

  assertSize = lib.assertMsg (lib.elem size validSizes) ''
    You entered a wrong size: ${size}
    Valid sizes are: ${toString validSizes}
  '';

  assertUnknown = lib.assertMsg (unknownTweaks == [ ]) ''
    You entered wrong tweaks: ${toString unknownTweaks}
    Valid tweaks are: ${toString validTweaks}
  '';
in

assert assertIllegal;
assert assertSize;
assert assertUnknown;

stdenvNoCC.mkDerivation rec {
  pname = "catppuccin-gtk";
  version = "0.2.7";

  src = fetchFromGitHub {
    repo = "gtk";
    owner = "catppuccin";
    rev = "v-${version}";
    sha256 = "sha256-oTAfURHMWqlKHk4CNz5cn6vO/7GmQJM2rXXGDz2e+0w=";
  };

  nativeBuildInputs = [ gtk3 sassc ];

  buildInputs = [ gnome-themes-extra ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = ''
    patchShebangs --build clean-old-theme.sh install.sh
  '';

  installPhase = ''
    runHook preInstall

    export HOME=$(mktemp -d)

    bash install.sh -d $out/share/themes -t all \
      ${lib.optionalString (size != "") "-s ${size}"} \
      ${lib.optionalString (tweaks != []) "--tweaks " + builtins.toString tweaks}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Soothing pastel theme for GTK";
    homepage = "https://github.com/catppuccin/gtk";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.fufexan ];
  };
}
