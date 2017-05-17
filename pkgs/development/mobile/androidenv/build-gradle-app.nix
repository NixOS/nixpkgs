{ stdenv, androidsdk, jdk, androidndk, gnumake, gawk, file, which, gradle, fetchurl, buildEnv }:

args@{ name, src, platformVersions ? [ "8" ], useGoogleAPIs ? false, useExtraSupportLibs ? false, useGooglePlayServices ? false
, release ? false, keyStore ? null, keyAlias ? null, keyStorePassword ? null, keyAliasPassword ? null
, useNDK ? false, buildInputs ? [], mavenDeps, gradleTask, buildDirectory ? "./.", acceptAndroidSdkLicenses ? false
}:

assert release -> keyStore != null && keyAlias != null && keyStorePassword != null && keyAliasPassword != null;
assert acceptAndroidSdkLicenses;

let
  m2install = { repo, version, artifactId, groupId, jarSha256, pomSha256, aarSha256, suffix ? "" }:
    let m2Name = "${artifactId}-${version}";
        m2Path = "${builtins.replaceStrings ["."] ["/"] groupId}/${artifactId}/${version}";
        m2PomFilename = "${m2Name}${suffix}.pom";
        m2JarFilename = "${m2Name}${suffix}.jar";
        m2AarFilename = "${m2Name}${suffix}.aar";
        m2Jar = 
          if jarSha256 == null
            then null
            else fetchurl {
              sha256 = jarSha256;
              url = "${repo}${m2Path}/${m2JarFilename}";
            };
        m2Pom =
          if pomSha256 == null
            then null
            else fetchurl {
              sha256 = pomSha256;
              url = "${repo}${m2Path}/${m2PomFilename}";
            };
        m2Aar = 
          if aarSha256 == null
            then null
            else fetchurl {
              sha256 = aarSha256;
              url = "${repo}${m2Path}/${m2AarFilename}";
            };
    in stdenv.mkDerivation rec {
      name = m2Name;
      inherit m2Name m2Path m2Pom m2Jar m2Aar m2JarFilename m2PomFilename m2AarFilename;

      installPhase = ''
        mkdir -p $out/m2/$m2Path
        ${if m2Jar != null 
            then "cp $m2Jar $out/m2/$m2Path/$m2JarFilename"
            else ""}
        ${if m2Pom != null
            then "cp $m2Pom $out/m2/$m2Path/$m2PomFilename"
            else ""}
        ${if m2Aar != null 
            then "cp $m2Aar $out/m2/$m2Path/$m2AarFilename"
            else ""}
      '';

      phases = "installPhase";
    };
  platformName = if stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux" then "linux"
    else if stdenv.system == "x86_64-darwin" then "macosx"
    else throw "Platform: ${stdenv.system} is not supported!";

  androidsdkComposition = androidsdk {
    inherit platformVersions useGoogleAPIs useExtraSupportLibs useGooglePlayServices;
    abiVersions = [ "armeabi-v7a" ];
  };
in
stdenv.mkDerivation ({
  name = stdenv.lib.replaceChars [" "] [""] name;

  ANDROID_HOME = "${androidsdkComposition}/libexec";
  ANDROID_NDK_HOME = "${androidndk}/libexec/android-ndk-r10e";

  buildInputs = [ jdk gradle ] ++
    stdenv.lib.optional useNDK [ androidndk gnumake gawk file which ] ++
      buildInputs;

  DEPENDENCIES = buildEnv { name = "${name}-maven-deps";
                            paths = map m2install mavenDeps;
                          };

  buildPhase = ''
    ${stdenv.lib.optionalString release ''
      # Provide key signing attributes
      ( echo "RELEASE_STORE_FILE=${keyStore}"
        echo "RELEASE_KEY_ALIAS=${keyAlias}"
        echo "RELEASE_STORE_PASSWORD=${keyStorePassword}"
        echo "RELEASE_KEY_PASSWORD=${keyAliasPassword}"
      ) >> gradle.properties
    ''}
    buildDir=`pwd`
    cp -r $ANDROID_HOME $buildDir/local_sdk
    chmod -R 755 local_sdk
    export ANDROID_HOME=$buildDir/local_sdk
    export ANDROID_SDK_HOME=`pwd` # Key files cannot be stored in the user's home directory. This overrides it.

    mkdir "$ANDROID_HOME/licenses" || true
    echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "$ANDROID_HOME/licenses/android-sdk-license"
    echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license"

    export APP_HOME=`pwd`

    mkdir -p .m2/repository
    for dep in $DEPENDENCIES ; do
      cp -RL $dep/m2/* .m2/repository/ ; done
    chmod -R 755 .m2
    mkdir -p .m2/repository/com/android/support
    cp -RL local_sdk/extras/android/m2repository/com/android/support/* .m2/repository/com/android/support/
    cp -RL local_sdk/extras/google/m2repository/* .m2/repository/
    gradle ${gradleTask} --offline --no-daemon -g ./tmp -Dmaven.repo.local=`pwd`/.m2/repository
  '';

  installPhase = ''
    mkdir -p $out
    mv ${buildDirectory}/build/outputs/apk/*.apk $out
    
    mkdir -p $out/nix-support
    echo "file binary-dist \"$(echo $out/*.apk)\"" > $out/nix-support/hydra-build-products
  '';
} //
builtins.removeAttrs args ["name" "mavenDeps"])
