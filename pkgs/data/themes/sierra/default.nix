{
  lib,
  stdenv,
  fetchFromGitHub,
  gdk-pixbuf,
  gtk-engine-murrine,
  jdupes,
  librsvg,
  libxml2,
  buttonVariants ? [ ], # default to all
  colorVariants ? [ ], # default to all
  opacityVariants ? [ ], # default to all
  sizeVariants ? [ ], # default to all
}:

let
  pname = "sierra-gtk-theme";
in
lib.checkListOfEnum "${pname}: button variants" [ "standard" "alt" ] buttonVariants
  lib.checkListOfEnum
  "${pname}: color variants"
  [ "light" "dark" ]
  colorVariants
  lib.checkListOfEnum
  "${pname}: opacity variants"
  [ "standard" "solid" ]
  opacityVariants
  lib.checkListOfEnum
  "${pname}: size variants"
  [ "standard" "compact" ]
  sizeVariants

  stdenv.mkDerivation
  {
    inherit pname;
    version = "unstable-2021-05-24";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = pname;
      rev = "05899001c4fc2fec87c4d222cb3997c414e0affd";
      sha256 = "174l5mryc34ma1r42pk6572c6i9hmzr9vj1a6w06nqz5qcfm1hds";
    };

    nativeBuildInputs = [
      jdupes
      libxml2
    ];

    buildInputs = [
      gdk-pixbuf
      librsvg
    ];

    propagatedUserEnvPkgs = [
      gtk-engine-murrine
    ];

    installPhase = ''
      runHook preInstall

      patchShebangs install.sh

      mkdir -p $out/share/themes
      name= ./install.sh --dest $out/share/themes \
        ${lib.optionalString (buttonVariants != [ ]) "--alt " + builtins.toString buttonVariants} \
        ${lib.optionalString (colorVariants != [ ]) "--color " + builtins.toString colorVariants} \
        ${lib.optionalString (opacityVariants != [ ]) "--opacity " + builtins.toString opacityVariants} \
        ${lib.optionalString (sizeVariants != [ ]) "--flat " + builtins.toString sizeVariants}

      # Replace duplicate files with hardlinks to the first file in each
      # set of duplicates, reducing the installed size in about 79%
      jdupes -L -r $out/share

      runHook postInstall
    '';

    meta = with lib; {
      description = "A Mac OSX like theme for GTK based desktop environments";
      homepage = "https://github.com/vinceliuice/Sierra-gtk-theme";
      license = licenses.gpl3;
      platforms = platforms.unix;
      maintainers = [ maintainers.romildo ];
    };
  }
