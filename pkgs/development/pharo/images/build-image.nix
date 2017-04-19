{ stdenv, fetchurl, bash, pharo-vm, unzip, makeDesktopItem, ... }:

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
  buildInputs = [ bash pharo-vm unzip ];

  # Create script to run the image.
  # Copies into a read/write directory first. Seems to be needed.
  buildPhase = ''
    cat > run.sh <<EOF
    #!${bash}/bin/bash
    tempdir=\$(mktemp -d)
    function cleanup { rm -rf \$tempdir; }
    trap cleanup EXIT
    cp $out/share/pharo-image/* \$tempdir
    chmod u+w \$tempdir/*.changes
    exec ${pharo-vm}/bin/pharo-vm \$tempdir/*.image "$@"
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

#  doInstallCheck = true;
  installCheckPhase = ''
    (set +e
     export HOME=.
     echo "starting image to check for crash..."
     timeout 3 $out/bin/${executable-name} -nodisplay --no-quit eval 'true'
     test "$?" == 123 && echo "ok")
  '';
}

