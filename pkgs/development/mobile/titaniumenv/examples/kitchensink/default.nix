{ titaniumenv, fetchgit, target, androidPlatformVersions ? [ "23" ], tiVersion ? "5.1.2.GA", release ? false
, rename ? false, stdenv ? null, newBundleId ? null, iosMobileProvisioningProfile ? null, iosCertificate ? null, iosCertificateName ? null, iosCertificatePassword ? null, iosVersion ? "8.1"
, enableWirelessDistribution ? false, installURL ? null
}:

assert rename -> (stdenv != null && newBundleId != null && iosMobileProvisioningProfile != null && iosCertificate != null && iosCertificateName != null && iosCertificatePassword != null);

let
  src = fetchgit {
    url = https://github.com/appcelerator/KitchenSink.git;
    rev = "ec9edebf35030f61368000a8a9071dd7a0773884";
    sha256 = "1j41w4nhcbl40x550pjgabqrach80f9dybv7ya32771wnw2000iy";
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
  
  inherit iosMobileProvisioningProfile iosCertificate iosCertificateName iosCertificatePassword iosVersion;
  inherit enableWirelessDistribution installURL;
}
