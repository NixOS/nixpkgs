{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, colloid-gtk-theme
, gnome-themes-extra
, gtk-engine-murrine
, python3
, sassc
, accents ? [ "blue" ]
, size ? "standard"
, tweaks ? [ ]
, variant ? "frappe"
}:
let
  validAccents = [ "blue" "flamingo" "green" "lavender" "maroon" "mauve" "peach" "pink" "red" "rosewater" "sapphire" "sky" "teal" "yellow" ];
  validSizes = [ "standard" "compact" ];
  validTweaks = [ "black" "rimless" "normal" ];
  validVariants = [ "latte" "frappe" "macchiato" "mocha" ];

  pname = "catppuccin-gtk";
in

lib.checkListOfEnum "${pname}: theme accent" validAccents accents
lib.checkListOfEnum "${pname}: color variant" validVariants [variant]
lib.checkListOfEnum "${pname}: size variant" validSizes [size]
lib.checkListOfEnum "${pname}: tweaks" validTweaks tweaks

stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "gtk";
    rev = "v${version}";
    sha256 = "sha256-b03V/c2do5FSm4Q0yN7V0RuoQX1fYsBd//Hj3R5MESI=";
  };

  nativeBuildInputs = [ gtk3 sassc ];

  buildInputs = [
    gnome-themes-extra
    (python3.withPackages (ps: [ ps.catppuccin ]))
  ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postUnpack = ''
    rm -rf source/colloid
    cp -r ${colloid-gtk-theme.src} source/colloid
    chmod -R +w source/colloid
  '';

  postPatch = ''
    patchShebangs --build colloid/clean-old-theme.sh colloid/install.sh
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    export HOME=$(mktemp -d)

    python3 install.py ${variant} \
      ${lib.optionalString (accents != []) "--accent " + builtins.toString accents} \
      ${lib.optionalString (size != []) "--size " + size} \
      ${lib.optionalString (tweaks != []) "--tweaks " + builtins.toString tweaks} \
      --dest $out/share/themes

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
