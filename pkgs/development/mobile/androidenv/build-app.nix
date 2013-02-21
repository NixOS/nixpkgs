{ stdenv, androidsdk, jdk, ant }:
{ name, src, platformVersions ? [ "8" ], useGoogleAPIs ? false
, release ? false, keyStore ? null, keyAlias ? null, keyStorePassword ? null, keyAliasPassword ? null
}:

assert release -> keyStore != null && keyAlias != null && keyStorePassword != null && keyAliasPassword != null;

let
  platformName = if stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux" then "linux"
    else if stdenv.system == "x86_64-darwin" then "macosx"
    else throw "Platform: ${stdenv.system} is not supported!";

  androidsdkComposition = androidsdk { inherit platformVersions useGoogleAPIs; };
in
stdenv.mkDerivation {
  inherit name src;
  
  ANDROID_HOME = "${androidsdkComposition}/libexec/android-sdk-${platformName}";

  buildInputs = [ jdk ant ];
  
  buildPhase = ''
    ${stdenv.lib.optionalString release ''
    
      # Provide key singing attributes
      ( echo "key.store=${keyStore}"
        echo "key.alias=${keyAlias}"
        echo "key.store.password=${keyStorePassword}"
        echo "key.alias.password=${keyAliasPassword}"
      ) >> ant.properties
    ''}
  
    export ANDROID_SDK_HOME=`pwd` # Key files cannot be stored in the user's home directory. This overrides it.
    ant ${if release then "release" else "debug"}
  '';
  
  installPhase = ''
    mkdir -p $out
    mv bin/*-${if release then "release" else "debug"}.apk $out
  '';
}
