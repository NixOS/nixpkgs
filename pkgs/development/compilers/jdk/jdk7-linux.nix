{ swingSupport ? true
, stdenv
, requireFile
, unzip
, file
, xlibs ? null
, installjdk ? true
, pluginSupport ? true
, installjce ? false
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";
assert swingSupport -> xlibs != null;

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
      abort "jdk requires i686-linux or x86_64 linux";

  jce =
    if installjce then
      requireFile {
        name = "UnlimitedJCEPolicyJDK7.zip";
        url = http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html;
        sha256 = "7a8d790e7bd9c2f82a83baddfae765797a4a56ea603c9150c87b7cdb7800194d";
      }
    else
      "";
in

stdenv.mkDerivation rec {
  patchversion = "51";

  name =
    if installjdk then "jdk-1.7.0_${patchversion}" else "jre-1.7.0_${patchversion}";

  src =
    if stdenv.system == "i686-linux" then
      requireFile {
        name = "jdk-7u${patchversion}-linux-i586.tar.gz";
        url = http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html;
        sha256 = "1ks2zyx88bxdjcbdgg40mh1i9a83ll9ymxr79rplfvj48ig9d8mk";
      }
    else if stdenv.system == "x86_64-linux" then

      requireFile {
        name = "jdk-7u${patchversion}-linux-x64.tar.gz";
        url = http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html;
        sha256 = "0p7mfjj8fxlghvhcqhwgrifzb32b9y143yw962zk02bfycz7qdkp";
      }
    else
      abort "jdk requires i686-linux or x86_64 linux";

  nativeBuildInputs = [ file ]
    ++ stdenv.lib.optional installjce unzip;

  installPhase = ''
    cd ..

    # Set PaX markings
    exes=$(file $sourceRoot/bin/* $sourceRoot/jre/bin/* 2> /dev/null | grep -E 'ELF.*(executable|shared object)' | sed -e 's/: .*$//')
    for file in $exes; do
      paxmark m "$file"
      # On x86 for heap sizes over 700MB disable SEGMEXEC and PAGEEXEC as well.
      ${stdenv.lib.optionalString stdenv.isi686 ''paxmark msp "$file"''}
    done

    if test -z "$installjdk"; then
      mv $sourceRoot/jre $out
    else
      mv $sourceRoot $out
    fi

    for file in $out/*
    do
      if test -f $file ; then
        rm $file
      fi
    done

    if test -n "$installjdk"; then
      for file in $out/jre/*
      do
        if test -f $file ; then
          rm $file
        fi
      done
    fi

    # construct the rpath
    rpath=
    for i in $libraries; do
        rpath=$rpath''${rpath:+:}$i/lib
    done

    if test -z "$installjdk"; then
      jrePath=$out
    else
      jrePath=$out/jre
    fi

    if test -n "${jce}"; then
      unzip ${jce}
      cp -v UnlimitedJCEPolicy/*.jar $jrePath/lib/security
    fi

    rpath=$rpath''${rpath:+:}$jrePath/lib/${architecture}/jli
    rpath=$rpath''${rpath:+:}$jrePath/lib/${architecture}

    # set all the dynamic linkers
    find $out -type f -perm +100 \
        -exec patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
        --set-rpath "$rpath" {} \;

    find $out -name "*.so" -exec patchelf --set-rpath "$rpath" {} \;

    if test -z "$pluginSupport"; then
      rm -f $out/bin/javaws
      if test -n "$installjdk"; then
        rm -f $out/jre/bin/javaws
      fi
    fi

    mkdir $jrePath/lib/${architecture}/plugins
    ln -s $jrePath/lib/${architecture}/libnpjp2.so $jrePath/lib/${architecture}/plugins
  '';

  inherit installjdk pluginSupport;

  /**
   * libXt is only needed on amd64
   */
  libraries =
    [stdenv.gcc.libc] ++
    (if swingSupport then [xlibs.libX11 xlibs.libXext xlibs.libXtst xlibs.libXi xlibs.libXp xlibs.libXt] else []);

  passthru.mozillaPlugin = if installjdk then "/jre/lib/${architecture}/plugins" else "/lib/${architecture}/plugins";

  meta.license = "unfree";
}

