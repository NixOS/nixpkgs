{titaniumenv, fetchgit, target, androidPlatformVersions ? [ "11" ]}:

titaniumenv.buildApp {
  name = "KitchenSink-${target}";
  appId = "com.appcelerator.kitchensink";
  src = fetchgit {
    url = https://github.com/appcelerator/KitchenSink.git;
    rev = "b68757ef6639e3da564e21038dc9c1aee1f80907";
    sha256 = "17yabdkl0p6pf2a2lcgw1kid2smwc8rnpx0i9fa4avj6930cbh5i";
  };
  
  inherit target androidPlatformVersions;
  
  /*release = true;
  androidKeyStore = /home/sander/keystore;
  androidKeyAlias = "sander";
  androidKeyStorePassword = "foobar";*/
  
  /*release = true;
  iosKeyFile = /Users/sander/Downloads/profile.mobileprovision;
  iosCertificateName = "My Company";
  iosCertificate = /Users/sander/Downloads/c.p12;
  iosCertificatePassword = "";*/
}
