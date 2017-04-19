{ stdenv, fetchurl, bash, pharo-vm, unzip, makeDesktopItem, xvfb_run, ... }:

basename: version: url: sha256:

stdenv.mkDerivation rec {
  name = "pharo-image-${image-name}";
  src = fetchurl { inherit url sha256; };
  image-name = "${basename}-${version}";
  executable-name = image-name;
  inherit version;
  desktopItem = makeDesktopItem rec {
    name = "Pharo-${image-name}";
    exec = "${executable-name}";
    icon = "pharo";
    comment = "Launcher for Pharo image ${image-name}";
    desktopName = "Pharo-${image-name}";
    genericName = desktopName;
    categories = "Development";
  };
  sourceRoot = ".";
  buildInputs = [ bash pharo-vm unzip xvfb_run ];

  # Create script to run the image.
  # Copies into a read/write directory first. Seems to be needed.
  buildPhase = ''
    cat > run.sh <<EOF
    #!${bash}/bin/bash
    prefix=\$(mktemp -u -p \$(pwd) -t "${name}-XXXXXXXX")
    trap "rm -f \$prefix.image \$prefix.changes" EXIT TERM INT HUP QUIT CHLD
    cp $out/share/pharo-image/*.image \$prefix.image
    cp $out/share/pharo-image/*.changes \$prefix.changes
    chmod u+w \$prefix.changes
    ${pharo-vm}/bin/pharo-vm \$prefix.image "\$@"
    EOF
  '';

  installPhase = ''
    # Create shell script
    mkdir -p $out/bin
    cp run.sh $out/bin/${image-name}
    chmod +x $out/bin/${image-name}

    # Copy image and changes files
    mkdir -p $out/share/pharo-image
    cp *.image *.changes $out/share/pharo-image/
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    (set +e
     export HOME=.
     echo "starting image to check for crash..."
     xvfb-run timeout 3 $out/bin/${executable-name}
     test "$?" == 124 && echo -e "OK.")
  '';
}

