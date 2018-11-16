{ titaniumenv, fetchgit, target, androidPlatformVersions ? [ "25" "26" ], tiVersion ? "7.1.0.GA", release ? false
, rename ? false, stdenv ? null, newBundleId ? null, iosMobileProvisioningProfile ? null, iosCertificate ? null, iosCertificateName ? null, iosCertificatePassword ? null, iosVersion ? "11.2"
, enableWirelessDistribution ? false, installURL ? null
}:

assert rename -> (stdenv != null && newBundleId != null && iosMobileProvisioningProfile != null && iosCertificate != null && iosCertificateName != null && iosCertificatePassword != null);

let
  src = fetchgit {
    url = https://github.com/appcelerator/kitchensink-v2.git;
    rev = "94364df2ef60a80bd354a4273e3cb5f4c5185537";
    sha256 = "0q4gzidpsq401frkngy4yk5kqvm8dz00ls74bw3fnpvg4714d6gf";
  };

  # Rename the bundle id to something else
  renamedSrc = stdenv.mkDerivation {
    name = "KitchenSink-renamedsrc";
    inherit src;
    buildPhase = ''
      sed -i -e "s|com.appcelerator.kitchensink|${newBundleId}|" tiapp.xml
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
