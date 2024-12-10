{
  sourcePerArch,
  knownVulnerabilities ? [ ],
}:

{
  swingSupport ? true, # not used for now
  lib,
  stdenv,
  fetchurl,
  setJavaClassPath,
}:

assert (stdenv.isDarwin && stdenv.isx86_64);

let
  cpuName = stdenv.hostPlatform.parsed.cpu.name;
  result = stdenv.mkDerivation {
    pname =
      if sourcePerArch.packageType == "jdk" then
        "adoptopenjdk-${sourcePerArch.vmType}-bin"
      else
        "adoptopenjdk-${sourcePerArch.packageType}-${sourcePerArch.vmType}-bin";
    version = sourcePerArch.${cpuName}.version or (throw "unsupported CPU ${cpuName}");

    src = fetchurl {
      inherit (sourcePerArch.${cpuName}) url sha256;
    };

    # See: https://github.com/NixOS/patchelf/issues/10
    dontStrip = 1;

    installPhase = ''
      cd ..

      mv $sourceRoot $out

      # jni.h expects jni_md.h to be in the header search path.
      ln -s $out/Contents/Home/include/darwin/*_md.h $out/Contents/Home/include/

      rm -rf $out/Home/demo

      # Remove some broken manpages.
      rm -rf $out/Home/man/ja*

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
    passthru.jre = result;

    passthru.home = result;

    meta = with lib; {
      license = licenses.gpl2Classpath;
      description = "AdoptOpenJDK, prebuilt OpenJDK binary";
      platforms = [ "x86_64-darwin" ]; # some inherit jre.meta.platforms
      maintainers = with lib.maintainers; [ taku0 ];
      inherit knownVulnerabilities;
      mainProgram = "java";
    };

  };
in
result
