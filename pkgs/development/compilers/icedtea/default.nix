{ stdenv, fetchurl, jdk, jdkPath, ant, wget, zip, unzip, cpio, file, libxslt
, xorg, zlib, pkgconfig, libjpeg, libpng, giflib, lcms2, gtk2, krb5, attr
, alsaLib, procps, automake, autoconf, cups, which, perl, coreutils, binutils
, cacert, setJavaClassPath
}:

let

  /**
   * The JRE libraries are in directories that depend on the CPU.
   */
  architecture =
    if stdenv.system == "i686-linux" then
      "i386"
    else if stdenv.system == "x86_64-linux" then
      "amd64"
    else
      throw "icedtea requires i686-linux or x86_64 linux";

  srcInfo = (import ./sources.nix).icedtea7;

  pkgName = "icedtea7-${srcInfo.version}";

  defSrc = name:
    with (builtins.getAttr name srcInfo.bundles); fetchurl {
      inherit url sha256;
      name = "${pkgName}-${name}-${baseNameOf url}";
    };

  bundleNames = builtins.attrNames srcInfo.bundles;

  sources = stdenv.lib.genAttrs bundleNames (name: defSrc name);

  bundleFun = name: "--with-${name}-src-zip=" + builtins.getAttr name sources;
  bundleFlags = map bundleFun bundleNames;

in

with srcInfo; stdenv.mkDerivation {
  name = pkgName;

  src = fetchurl {
    inherit url sha256;
  };

  outputs = [ "out" "jre" ];

  # TODO: Probably some more dependencies should be on this list but are being
  # propagated instead
  buildInputs = [
    jdk ant wget zip unzip cpio file libxslt pkgconfig procps automake
    autoconf which perl coreutils xorg.lndir
    zlib libjpeg libpng giflib lcms2 krb5 attr alsaLib cups
    xorg.libX11 xorg.libXtst gtk2
  ];

  configureFlags = bundleFlags ++ [
    "--disable-bootstrap"
    "--disable-downloading"

    "--without-rhino"
    "--with-pax=paxctl"
    "--with-jdk-home=${jdkPath}"
  ];

  preConfigure = ''
    unset JAVA_HOME JDK_HOME CLASSPATH JAVAC JAVACFLAGS

    substituteInPlace javac.in --replace '#!/usr/bin/perl' '#!${perl}/bin/perl'
    substituteInPlace javah.in --replace '#!/usr/bin/perl' '#!${perl}/bin/perl'

    ./autogen.sh
  '';

  preBuild = ''
    make stamps/extract.stamp

    substituteInPlace openjdk/jdk/make/common/shared/Defs-utils.gmk --replace '/bin/echo' '${coreutils}/bin/echo'
    substituteInPlace openjdk/corba/make/common/shared/Defs-utils.gmk --replace '/bin/echo' '${coreutils}/bin/echo'

    patch -p0 < ${./cppflags-include-fix.patch}
    patch -p0 < ${./fix-java-home.patch}
  '';

  NIX_NO_SELF_RPATH = true;

  makeFlags = [
    "ALSA_INCLUDE=${alsaLib}/include/alsa/version.h"
    "ALT_UNIXCOMMAND_PATH="
    "ALT_USRBIN_PATH="
    "ALT_DEVTOOLS_PATH="
    "ALT_COMPILER_PATH="
    "ALT_CUPS_HEADERS_PATH=${cups}/include"
    "ALT_OBJCOPY=${binutils}/bin/objcopy"
    "SORT=${coreutils}/bin/sort"
    "UNLIMITED_CRYPTO=1"
  ];

  installPhase = ''
    mkdir -p $out/lib/icedtea $out/share $jre/lib/icedtea

    cp -av openjdk.build/j2sdk-image/* $out/lib/icedtea

    # Move some stuff to top-level.
    mv $out/lib/icedtea/include $out/include
    mv $out/lib/icedtea/man $out/share/man

    # jni.h expects jni_md.h to be in the header search path.
    ln -s $out/include/linux/*_md.h $out/include/

    # Remove some broken manpages.
    rm -rf $out/share/man/ja*

    # Remove crap from the installation.
    rm -rf $out/lib/icedtea/demo $out/lib/icedtea/sample

    # Move the JRE to a separate output.
    mv $out/lib/icedtea/jre $jre/lib/icedtea/
    mkdir $out/lib/icedtea/jre
    lndir $jre/lib/icedtea/jre $out/lib/icedtea/jre

    # The following files cannot be symlinked, as it seems to violate Java security policies
    rm $out/lib/icedtea/jre/lib/ext/*
    cp $jre/lib/icedtea/jre/lib/ext/* $out/lib/icedtea/jre/lib/ext/

    rm -rf $out/lib/icedtea/jre/bin
    ln -s $out/lib/icedtea/bin $out/lib/icedtea/jre/bin

    # Remove duplicate binaries.
    for i in $(cd $out/lib/icedtea/bin && echo *); do
      if [ "$i" = java ]; then continue; fi
      if cmp -s $out/lib/icedtea/bin/$i $jre/lib/icedtea/jre/bin/$i; then
        ln -sfn $jre/lib/icedtea/jre/bin/$i $out/lib/icedtea/bin/$i
      fi
    done

    # Generate certificates.
    pushd $jre/lib/icedtea/jre/lib/security
    rm cacerts
    perl ${./generate-cacerts.pl} $jre/lib/icedtea/jre/bin/keytool ${cacert}/etc/ca-bundle.crt
    popd

    ln -s $out/lib/icedtea/bin $out/bin
    ln -s $jre/lib/icedtea/jre/bin $jre/bin
  '';

  # FIXME: this is unnecessary once the multiple-outputs branch is merged.
  preFixup = ''
    prefix=$jre stripDirs "$stripDebugList" "''${stripDebugFlags:--S}"
    patchELF $jre
    propagatedNativeBuildInputs+=" $jre"

    # Propagate the setJavaClassPath setup hook from the JRE so that
    # any package that depends on the JRE has $CLASSPATH set up
    # properly.
    mkdir -p $jre/nix-support
    echo -n "${setJavaClassPath}" > $jre/nix-support/propagated-native-build-inputs

    # Set JAVA_HOME automatically.
    mkdir -p $out/nix-support
    cat <<EOF > $out/nix-support/setup-hook
    if [ -z "\$JAVA_HOME" ]; then export JAVA_HOME=$out/lib/icedtea; fi
    EOF
  '';

  meta = {
    description = "Free Java development kit based on OpenJDK 7.0 and the IcedTea project";
    longDescription = ''
      Free Java environment based on OpenJDK 7.0 and the IcedTea project.
      - Full Java runtime environment
      - Needed for executing Java Webstart programs and the free Java web browser plugin.
    '';
    homepage = http://icedtea.classpath.org;
    maintainers = with stdenv.lib.maintainers; [ wizeman ];
    platforms = stdenv.lib.platforms.linux;
  };

  passthru = { inherit architecture; };
}
