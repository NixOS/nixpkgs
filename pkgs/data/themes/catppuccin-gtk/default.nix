{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, gnome-themes-extra
, gtk-engine-murrine
, sassc
, which
, tweaks ? [ ]         # can be "nord" "black" "rimless". cannot mix "nord" and "black"
, size ? "standard"    # can be "standard" "compact"
}:
let
  validSizes = [ "standard" "compact" ];
  validTweaks = [ "nord" "black" "rimless" ];

  unknownTweaks = lib.subtractLists validTweaks tweaks;
  illegalMix = !(lib.elem "nord" tweaks) && !(lib.elem "black" tweaks);

  assertIllegal = lib.assertMsg illegalMix ''
    Tweaks "nord" and "black" cannot be mixed. Tweaks: ${toString tweaks}
  '';

  assertSize = lib.assertMsg (lib.elem size validSizes) ''
    You entered wrong size: ${size}
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
  version = "unstable-2022-02-24";

  src = fetchFromGitHub {
    repo = "gtk";
    owner = "catppuccin";
    rev = "359c584f607c021fcc657ce77b81c181ebaff6de";
    sha256 = "sha256-AVhFw1XTnkU0hoM+UyjT7ZevLkePybBATJUMLqRytpk=";
  };

  nativeBuildInputs = [ gtk3 sassc which ];

  buildInputs = [ gnome-themes-extra ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  patches = [
    # Allows installing with `-t all`. Works around missing grey assets.
    # https://github.com/catppuccin/gtk/issues/17
    ./grey-fix.patch
  ];

  postPatch = ''
    patchShebangs --build scripts/*
    substituteInPlace Makefile \
      --replace '$(shell git rev-parse --show-toplevel)' "$PWD"
    substituteInPlace 'scripts/install.sh' \
      --replace '$(git rev-parse --show-toplevel)' "$PWD"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    bash scripts/install.sh -d $out/share/themes -t all \
      ${lib.optionalString (size != "") "-s ${size}"} \
      ${lib.optionalString (tweaks != []) "--tweaks " + builtins.toString tweaks}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Soothing pastel theme for GTK3";
    homepage = "https://github.com/catppuccin/gtk";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.fufexan ];
  };
}
