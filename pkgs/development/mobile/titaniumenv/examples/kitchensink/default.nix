{titaniumenv, fetchgit, target, androidPlatformVersions ? [ "11" ]}:

titaniumenv.buildApp {
  name = "KitchenSink-${target}";
  appName = "KitchenSink";
  appId = "com.appcelerator.kitchensink";
  src = fetchgit {
    url = https://github.com/appcelerator/KitchenSink.git;
    rev = "d9f39950c0137a1dd67c925ef9e8046a9f0644ff";
    sha256 = "0aj42ac262hw9n9blzhfibg61kkbp3wky69rp2yhd11vwjlcq1qc";
  };
  
  inherit target androidPlatformVersions;
  
  /*release = true;
  androidKeyStore = /home/sander/keystore;
  androidKeyAlias = "sander";
  androidKeyStorePassword = "foobar";*/
  
  /*release = true;
  iosMobileProvisioningProfile = /Users/sander/Downloads/profile.mobileprovision;
  iosCertificateName = "My Company";
  iosCertificate = /Users/sander/Downloads/c.p12;
  iosCertificatePassword = "";*/
}
