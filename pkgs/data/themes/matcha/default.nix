{ lib
, stdenvNoCC
, fetchFromGitHub
, gdk-pixbuf
, gtk-engine-murrine
, jdupes
, librsvg
, gitUpdater
, colorVariants ? [] # default: all
, themeVariants ? [] # default: blue
}:

let
  pname = "matcha-gtk-theme";

in
lib.checkListOfEnum "${pname}: color variants" [ "standard" "light" "dark" ] colorVariants
lib.checkListOfEnum "${pname}: theme variants" [ "aliz" "azul" "sea" "pueril" "all" ] themeVariants

stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "2023-04-03";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "mr9X7p/H8H2QKZxAQC9j/8OLK4D3EnWLxriFlh16diE=";
  };

  nativeBuildInputs = [
    jdupes
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
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

    name= ./install.sh \
      ${lib.optionalString (colorVariants != []) "--color " + builtins.toString colorVariants} \
      ${lib.optionalString (themeVariants != []) "--theme " + builtins.toString themeVariants} \
      --dest $out/share/themes

    mkdir -p $out/share/doc/${pname}
    cp -a src/extra/firefox $out/share/doc/${pname}

    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "A stylish flat Design theme for GTK based desktop environments";
    homepage = "https://vinceliuice.github.io/theme-matcha";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
