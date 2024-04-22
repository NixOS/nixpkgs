{ name-prefix ? "temurin"
, brand-name ? "Eclipse Temurin"
, sourcePerArch
, knownVulnerabilities ? []
}:

{ swingSupport ? true # not used for now
, lib, stdenv
, fetchurl
, setJavaClassPath
}:

let
  cpuName = stdenv.hostPlatform.parsed.cpu.name;
  validCpuTypes = builtins.attrNames lib.systems.parse.cpuTypes;
  providedCpuTypes = builtins.filter
    (arch: builtins.elem arch validCpuTypes)
    (builtins.attrNames sourcePerArch);
  result = stdenv.mkDerivation {
    pname = if sourcePerArch.packageType == "jdk"
      then "${name-prefix}-bin"
      else "${name-prefix}-${sourcePerArch.packageType}-bin";
    version =
      sourcePerArch.${cpuName}.version or (throw "unsupported CPU ${cpuName}");

    src = fetchurl {
      inherit (sourcePerArch.${cpuName} or (throw "unsupported system ${stdenv.hostPlatform.system}")) url sha256;
    };

    # See: https://github.com/NixOS/patchelf/issues/10
    dontStrip = 1;

    installPhase = ''
      cd ..

      mv $sourceRoot $out

      # jni.h expects jni_md.h to be in the header search path.
      ln -s $out/Contents/Home/include/darwin/*_md.h $out/Contents/Home/include/

      # Remove some broken manpages.
      # Only for 11 and earlier.
      [ -e "$out/Contents/Home/man/ja" ] && rm -r $out/Contents/Home/man/ja

      ln -s $out/Contents/Home/* $out/

      # Propagate the setJavaClassPath setup hook from the JDK so that
      # any package that depends on the JDK has $CLASSPATH set up
      # properly.
      mkdir -p $out/nix-support
      printWords ${setJavaClassPath} > $out/nix-support/propagated-build-inputs

      # Set JAVA_HOME automatically.
      cat <<EOF >> $out/nix-support/setup-hook
      if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
      EOF
    '';

    # FIXME: use multiple outputs or return actual JRE package
    passthru = {
      jre = result;
      home = result;
    };

    meta = with lib; {
      license = licenses.gpl2Classpath;
      sourceProvenance = with sourceTypes; [ binaryNativeCode binaryBytecode ];
      description = "${brand-name}, prebuilt OpenJDK binary";
      platforms = builtins.map (arch: arch + "-darwin") providedCpuTypes;  # some inherit jre.meta.platforms
      maintainers = with maintainers; [ taku0 ];
      inherit knownVulnerabilities;
      mainProgram = "java";
    };
  };
in result
