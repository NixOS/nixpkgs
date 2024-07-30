{ lib
, stdenvNoCC
, fetchFromGitHub
, gnome-shell
, gtk-engine-murrine
, gtk_engines
, jdupes
, sassc
, gitUpdater
, themeVariants ? [] # default: doder (blue)
, colorVariants ? [] # default: all
, sizeVariants ? [] # default: standard
, tweaks ? []
}:

let
  pname = "vimix-gtk-themes";

in
lib.checkListOfEnum "${pname}: theme variants" [ "doder" "beryl" "ruby" "amethyst" "jade" "grey" "all" ] themeVariants
lib.checkListOfEnum "${pname}: color variants" [ "standard" "light" "dark" ] colorVariants
lib.checkListOfEnum "${pname}: size variants" [ "standard" "compact" "all" ] sizeVariants
lib.checkListOfEnum "${pname}: tweaks" [ "flat" "grey" "mix" "translucent" ] tweaks

stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "2024-04-20";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "RbAdoix+UWKiLB+04YiPa0UwzO1fFLy56IG1MipmE+E=";
  };

  nativeBuildInputs = [
    gnome-shell  # needed to determine the gnome-shell version
    jdupes
    sassc
  ];

  buildInputs = [
    gtk_engines
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  postPatch = ''
    patchShebangs install.sh
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    name= HOME="$TMPDIR" ./install.sh \
      ${lib.optionalString (themeVariants != []) "--theme " + builtins.toString themeVariants} \
      ${lib.optionalString (colorVariants != []) "--color " + builtins.toString colorVariants} \
      ${lib.optionalString (sizeVariants != []) "--size " + builtins.toString sizeVariants} \
      ${lib.optionalString (tweaks != []) "--tweaks " + builtins.toString tweaks} \
      --dest $out/share/themes
    rm $out/share/themes/*/{AUTHORS,LICENSE}
    jdupes --quiet --link-soft --recurse $out/share
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Flat Material Design theme for GTK based desktop environments";
    homepage = "https://github.com/vinceliuice/vimix-gtk-themes";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
