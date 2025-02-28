{
  lib,
  stdenv,
  fetchurl,
  jre,
  unzip,
  runtimeShell,
}:

stdenv.mkDerivation {
  pname = "umlet";
  version = "15.1.0";

  src = fetchurl {
    # NOTE: The download URL breaks consistency - sometimes w/ patch versions
    # and sometimes w/o. Furthermore, for 15.1.0 they moved everything to the
    # new /download subfolder.
    # As releases are very rarely, just modify it by hand..
    url = "https://www.umlet.com/download/umlet_15_1/umlet-standalone-15.1.zip";
    hash = "sha256-M6oVWbOmPBTygS+TFkY9PWucFfYLD33suNUuWpFLMIo=";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/lib"

    cp -R * "$out/lib"

    cat > "$out/bin/umlet" << EOF
    #!${runtimeShell}

    programDir="$out/lib"
    cd "\$programDir"
    if [ \$# -eq 1 ]
     then "${jre}/bin/java" -jar "\$programDir/umlet.jar" -filename="\$1"
     else "${jre}/bin/java" -jar "\$programDir/umlet.jar" "\$@"
    fi

    EOF
    chmod a+x "$out/bin/umlet"
  '';

  meta = with lib; {
    description = "Free, open-source UML tool with a simple user interface";
    longDescription = ''
      UMLet is a free, open-source UML tool with a simple user interface:
      draw UML diagrams fast, produce sequence and activity diagrams from
      plain text, export diagrams to eps, pdf, jpg, svg, and clipboard,
      share diagrams using Eclipse, and create new, custom UML elements.
      UMLet runs stand-alone or as Eclipse plug-in on Windows, macOS and
      Linux.
    '';
    homepage = "https://www.umlet.com";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3;
    maintainers = with maintainers; [ oxzi ];
    platforms = platforms.all;
    mainProgram = "umlet";
  };
}
