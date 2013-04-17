{androidenv, kitchensink}:

androidenv.emulateApp {
  name = "kitchensink";
  app = kitchensink;
  platformVersion = "16";
  useGoogleAPIs = true;
  package = "com.appcelerator.kitchensink";
  activity = "KitchensinkActivity";
}
