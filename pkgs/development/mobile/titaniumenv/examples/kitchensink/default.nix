{ titaniumenv, fetchgit, target, androidPlatformVersions ? [ "25" "26" ], tiVersion ? "6.3.1.GA", release ? false
, rename ? false, stdenv ? null, newBundleId ? null, iosMobileProvisioningProfile ? null, iosCertificate ? null, iosCertificateName ? null, iosCertificatePassword ? null, iosVersion ? "11.2"
, enableWirelessDistribution ? false, installURL ? null
}:

assert rename -> (stdenv != null && newBundleId != null && iosMobileProvisioningProfile != null && iosCertificate != null && iosCertificateName != null && iosCertificatePassword != null);

let
  src = fetchgit {
    url = https://github.com/appcelerator/KitchenSink.git;
    rev = "ec9edebf35030f61368000a8a9071dd7a0773884";
    sha256 = "3e020004b73c9c2386f2672fdf9203083295f1524f5e504a07842e062de181c8";
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
  preBuild = ''
    sed -i -e "s|23|25|" tiapp.xml
  ''; # Raise minimum android SDK from 23 to 25
  inherit tiVersion;

  inherit target androidPlatformVersions release;

  androidKeyStore = ./keystore;
  androidKeyAlias = "myfirstapp";
  androidKeyStorePassword = "mykeystore";

  inherit iosMobileProvisioningProfile iosCertificate iosCertificateName iosCertificatePassword iosVersion;
  inherit enableWirelessDistribution installURL;
}
