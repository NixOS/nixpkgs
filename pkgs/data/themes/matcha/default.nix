{ lib
, stdenvNoCC
, fetchFromGitHub
, gdk-pixbuf
, gtk-engine-murrine
, jdupes
, librsvg
, gitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "matcha-gtk-theme";
  version = "2022-11-15";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "Rx22O8C7kbYADxqJF8u6kdcQnXNA5aS+NWOnx/X4urY=";
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
    name= ./install.sh --dest $out/share/themes
    install -D -t $out/share/gtksourceview-3.0/styles src/extra/gedit/matcha.xml
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
