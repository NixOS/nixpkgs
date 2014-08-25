{ titaniumenv, fetchgit, target, androidPlatformVersions ? [ "14" ], tiVersion ? "3.2.3.GA", release ? false
, rename ? false, stdenv ? null, newBundleId ? null, iosMobileProvisioningProfile ? null, iosCertificate ? null, iosCertificateName ? null, iosCertificatePassword ? null
, enableWirelessDistribution ? false, installURL ? null
}:

assert rename -> (stdenv != null && newBundleId != null && iosMobileProvisioningProfile != null && iosCertificate != null && iosCertificateName != null && iosCertificatePassword != null);

let
  src = fetchgit {
    url = https://github.com/appcelerator/KitchenSink.git;
    rev = "37d766ef9cba6a2d0b22634d3edc1fa8402109a0";
    sha256 = "1d4x9zwq92p1krds52bd41qqsnsnb3a7x74bysbiphrvrphz80kk";
  };
  
  # Rename the bundle id to something else
  renamedSrc = stdenv.mkDerivation {
    name = "KitchenSink-renamedsrc";
    inherit src;
    buildPhase = ''
      sed -i -e "s|com.appcelerator.kitchensink|${newBundleId}|" tiapp.xml
      sed -i -e "s|com.appcelerator.kitchensink|${newBundleId}|" manifest
    '';
    installPhase = ''
      mkdir -p $out
      mv * $out
    '';
  };
in
titaniumenv.buildApp {
  name = "KitchenSink-${target}-${if release then "release" else "debug"}";
  src = if rename then renamedSrc else src;
  inherit tiVersion;
  
  inherit target androidPlatformVersions release;
  
  androidKeyStore = ./keystore;
  androidKeyAlias = "myfirstapp";
  androidKeyStorePassword = "mykeystore";
  
  inherit iosMobileProvisioningProfile iosCertificate iosCertificateName iosCertificatePassword;
  inherit enableWirelessDistribution installURL;
}
