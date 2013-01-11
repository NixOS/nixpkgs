{titaniumenv, fetchgit, target, androidPlatformVersions ? [ "8" ]}:

titaniumenv.buildApp {
  name = "KitchenSink";
  appId = "com.appcelerator.kitchensink";
  src = fetchgit {
    url = https://github.com/appcelerator/KitchenSink.git;
    rev = "0f2c0b818034cc4e6867f0aa2afc98bf77dbff02";
    sha256 = "de31496cfb5625d7a193bbbc32a8021e4094ffab20ae13ef2e1583b0394d7c60";
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
