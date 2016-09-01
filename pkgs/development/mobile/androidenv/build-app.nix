{ stdenv, androidsdk, jdk, ant, androidndk, gnumake, gawk, file, which }:
args@{ name, src, platformVersions ? [ "8" ], useGoogleAPIs ? false, antFlags ? ""
, release ? false, keyStore ? null, keyAlias ? null, keyStorePassword ? null, keyAliasPassword ? null
, useNDK ? false, ...
}:

assert release -> keyStore != null && keyAlias != null && keyStorePassword != null && keyAliasPassword != null;

let
  platformName = if stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux" then "linux"
    else if stdenv.system == "x86_64-darwin" then "macosx"
    else throw "Platform: ${stdenv.system} is not supported!";

  androidsdkComposition = androidsdk {
    inherit platformVersions useGoogleAPIs;
    abiVersions = [];
  };
in
stdenv.mkDerivation ({
  name = stdenv.lib.replaceChars [" "] [""] name;

  ANDROID_HOME = "${androidsdkComposition}/libexec";

  buildInputs = [ jdk ant ] ++
    stdenv.lib.optional useNDK [ androidndk gnumake gawk file which ];

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
    ${if useNDK then ''
        export GNUMAKE=${gnumake}/bin/make
        export NDK_HOST_AWK=${gawk}/bin/gawk
        ${androidndk}/bin/ndk-build
      '' else ""}
    ant ${antFlags} ${if release then "release" else "debug"}
  '';

  installPhase = ''
    mkdir -p $out
    mv bin/*-${if release then "release" else "debug"}.apk $out
    
    mkdir -p $out/nix-support
    echo "file binary-dist \"$(echo $out/*.apk)\"" > $out/nix-support/hydra-build-products
  '';
} //
builtins.removeAttrs args ["name"])
