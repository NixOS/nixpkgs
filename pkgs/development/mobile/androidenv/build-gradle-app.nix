{ stdenv, androidsdk, jdk, androidndk, gnumake, gawk, file
, which, gradle, fetchurl, buildEnv, runCommand }:

args@{ name, src, platformVersions ? [ "8" ], useGoogleAPIs ? false
     , useExtraSupportLibs ? false, useGooglePlayServices ? false
     , release ? false, keyStore ? null, keyAlias ? null
     , keyStorePassword ? null, keyAliasPassword ? null
     , useNDK ? false, buildInputs ? [], mavenDeps, gradleTask
     , buildDirectory ? "./.", acceptAndroidSdkLicenses ? false }:

assert release -> keyStore != null;
assert release -> keyAlias != null;
assert release -> keyStorePassword != null;
assert release -> keyAliasPassword != null;
assert acceptAndroidSdkLicenses;

let
  inherit (stdenv.lib) optionalString;

  m2install = { repo, version, artifactId, groupId
              , jarSha256, pomSha256, aarSha256, suffix ? "" }:
    let m2Name = "${artifactId}-${version}";
        m2Path = "${builtins.replaceStrings ["."] ["/"] groupId}/${artifactId}/${version}";
    in runCommand m2Name {} (''
         mkdir -p $out/m2/${m2Path}
       '' + optionalString (jarSha256 != null) ''
         install -D ${fetchurl {
                        url = "${repo}${m2Path}/${m2Name}${suffix}.jar";
                        sha256 = jarSha256;
                      }} $out/m2/${m2Path}/${m2Name}${suffix}.jar
       '' + optionalString (pomSha256 != null) ''
         install -D ${fetchurl {
                        url = "${repo}${m2Path}/${m2Name}${suffix}.pom";
                        sha256 = pomSha256;
                      }} $out/m2/${m2Path}/${m2Name}${suffix}.pom
       '' + optionalString (aarSha256 != null) ''
         install -D ${fetchurl {
                        url = "${repo}${m2Path}/${m2Name}${suffix}.aar";
                        sha256 = aarSha256;
                      }} $out/m2/${m2Path}/${m2Name}${suffix}.aar
       '');

  androidsdkComposition = androidsdk {
    inherit platformVersions useGoogleAPIs
            useExtraSupportLibs useGooglePlayServices;
    abiVersions = [ "armeabi-v7a" ];
  };
in
stdenv.mkDerivation ({
  name = stdenv.lib.replaceChars [" "] [""] name;

  ANDROID_HOME = "${androidsdkComposition}/libexec";
  ANDROID_NDK_HOME = "${androidndk}/libexec/${androidndk.name}";

  buildInputs = [ jdk gradle ] ++
    stdenv.lib.optional useNDK [ androidndk gnumake gawk file which ] ++
      buildInputs;

  DEPENDENCIES = buildEnv { name = "${name}-maven-deps";
                            paths = map m2install mavenDeps;
                          };

  buildPhase = ''
    ${optionalString release ''
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
    # Key files cannot be stored in the user's home directory. This
    # overrides it.
    export ANDROID_SDK_HOME=`pwd`

    mkdir -p "$ANDROID_HOME/licenses"
    echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "$ANDROID_HOME/licenses/android-sdk-license"
    echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license"

    export APP_HOME=`pwd`

    mkdir -p .m2/repository
    if [ -d "$DEPENDENCIES/m2" ] ; then
      cp -RL "$DEPENDENCIES"/m2/* .m2/repository/
    fi
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

  meta = {
    license = stdenv.lib.licenses.unfree;
  };
} // builtins.removeAttrs args ["name" "mavenDeps"])
