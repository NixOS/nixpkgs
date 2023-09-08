{ stdenv, lib, androidenv, jdk, gnumake, gawk, file
, which, gradle, fetchurl, buildEnv, runCommand }:

args@{ name, src, platformVersions ? [ "8" ]
     , buildToolsVersions ? [ "30.0.2" ]
     , useGoogleAPIs ? false, useGooglePlayServices ? false
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
  inherit (lib) optionalString optional;

  m2install = { repo, version, artifactId, groupId
              , jarSha256, pomSha256, aarSha256, suffix ? ""
              , customJarUrl ? null, customJarSuffix ? null }:
    let m2Name = "${artifactId}-${version}";
        m2Path = "${builtins.replaceStrings ["."] ["/"] groupId}/${artifactId}/${version}";
        jarFile = fetchurl {
          url = if customJarUrl != null then customJarUrl else "${repo}${m2Path}/${m2Name}${suffix}.jar";
          sha256 = jarSha256;
        };
    in runCommand m2Name {} (''
         installPath="$out"/m2/'${m2Path}'
         mkdir -p "$installPath"
       '' + optionalString (jarSha256 != null) ''
         install -D '${jarFile}' "$installPath"/'${m2Name}${suffix}.jar'
         ${optionalString (customJarSuffix != null) ''
           install -D '${jarFile}' "$installPath"/'${m2Name}${suffix}${customJarSuffix}.jar'
         ''}
       '' + optionalString (pomSha256 != null) ''
         install -D ${fetchurl {
                        url = "${repo}${m2Path}/${m2Name}${suffix}.pom";
                        sha256 = pomSha256;
                      }} "$installPath/${m2Name}${suffix}.pom"
       '' + optionalString (aarSha256 != null) ''
         install -D ${fetchurl {
                        url = "${repo}${m2Path}/${m2Name}${suffix}.aar";
                        sha256 = aarSha256;
                      }} "$installPath/${m2Name}${suffix}.aar"
       '');
  androidsdkComposition = androidenv.composeAndroidPackages {
    inherit platformVersions useGoogleAPIs buildToolsVersions;
    includeNDK = true;
    includeExtras = [ "extras;android;m2repository" ]
      ++ optional useGooglePlayServices "extras;google;google_play_services";
  };
in
stdenv.mkDerivation ({
  inherit src;
  name = builtins.replaceStrings [" "] [""] args.name;

  ANDROID_HOME = "${androidsdkComposition.androidsdk}/libexec";
  ANDROID_NDK_HOME = "${androidsdkComposition.ndk-bundle}/libexec/android-sdk/ndk-bundle";

  buildInputs = [ jdk gradle ] ++ buildInputs ++ lib.optional useNDK [ androidsdkComposition.ndk-bundle gnumake gawk file which ];

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
    ${optionalString (builtins.length buildToolsVersions > 0) ''
      echo "android.aapt2FromMavenOverride=local_sdk/android-sdk/build-tools/${builtins.head buildToolsVersions}/aapt2" >> gradle.properties
    ''}
    buildDir=`pwd`
    cp -rL $ANDROID_HOME $buildDir/local_sdk
    chmod -R 755 local_sdk
    export ANDROID_HOME=$buildDir/local_sdk/android-sdk
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
    cp -RL local_sdk/android-sdk/extras/android/m2repository/com/android/support/* .m2/repository/com/android/support/
    gradle ${gradleTask} --offline --no-daemon -g ./tmp -Dmaven.repo.local=$(pwd)/.m2/repository
  '';

  installPhase = ''
    mkdir -p $out
    ${if gradleTask == "bundleRelease"
    then "cp -RL build/outputs/bundle/release/*.aab $out"
    else "cp -RL build/outputs/apk/*/*.apk $out"}
  '';

  meta = {
    license = lib.licenses.unfree;
  };
} // builtins.removeAttrs args ["name" "mavenDeps"])
