{ composeAndroidPackages, stdenv, lib, ant, jdk, gnumake, gawk }:

{ name
, release ? false, keyStore ? null, keyAlias ? null, keyStorePassword ? null, keyAliasPassword ? null
, antFlags ? ""
, ...
}@args:

assert release -> keyStore != null && keyAlias != null && keyStorePassword != null && keyAliasPassword != null;

let
  androidSdkFormalArgs = lib.functionArgs composeAndroidPackages;
  androidArgs = builtins.intersectAttrs androidSdkFormalArgs args;
  androidsdk = (composeAndroidPackages androidArgs).androidsdk;

  extraArgs = removeAttrs args ([ "name" ] ++ builtins.attrNames androidSdkFormalArgs);
in
stdenv.mkDerivation ({
  name = lib.replaceStrings [" "] [""] name; # Android APKs may contain white spaces in their names, but Nix store paths cannot
  ANDROID_HOME = "${androidsdk}/libexec/android-sdk";
  buildInputs = [ jdk ant ];
  buildPhase = ''
    ${lib.optionalString release ''
      # Provide key singing attributes
      ( echo "key.store=${keyStore}"
        echo "key.alias=${keyAlias}"
        echo "key.store.password=${keyStorePassword}"
        echo "key.alias.password=${keyAliasPassword}"
      ) >> ant.properties
    ''}

    export ANDROID_SDK_HOME=`pwd` # Key files cannot be stored in the user's home directory. This overrides it.

    ${lib.optionalString (args ? includeNDK && args.includeNDK) ''
      export GNUMAKE=${gnumake}/bin/make
      export NDK_HOST_AWK=${gawk}/bin/gawk
      ${androidsdk}/libexec/android-sdk/ndk-bundle/ndk-build
    ''}
    ant ${antFlags} ${if release then "release" else "debug"}
  '';
  installPhase = ''
    mkdir -p $out
    mv bin/*-${if release then "release" else "debug"}.apk $out

    mkdir -p $out/nix-support
    echo "file binary-dist \"$(echo $out/*.apk)\"" > $out/nix-support/hydra-build-products
  '';
} // extraArgs)
