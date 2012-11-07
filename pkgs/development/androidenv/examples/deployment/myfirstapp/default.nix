{androidenv}:

androidenv.buildApp {
  name = "MyFirstApp";
  src = ../../src/myfirstapp;
  platformVersions = [ "16" ];
  useGoogleAPIs = true;
  /*release = true;
  keyStore = /home/sander/keystore;
  keyAlias = "sander";
  keyStorePassword = "foobar";
  keyAliasPassword = "foobar";*/
}
