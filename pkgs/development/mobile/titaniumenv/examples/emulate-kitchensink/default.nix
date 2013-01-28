{androidenv, kitchensink}:

androidenv.emulateApp {
  name = "kitchensink";
  app = kitchensink;
  platformVersion = "8";
  useGoogleAPIs = true;
  package = "com.appcelerator.kitchensink";
  activity = "KitchensinkActivity";
}
