{androidenv, kitchensink}:

androidenv.emulateApp {
  name = "emulate-${kitchensink.name}";
  app = kitchensink;
  platformVersion = "16";
  useGoogleAPIs = true;
  package = "com.appcelerator.kitchensink";
  activity = ".KitchensinkActivity";
}
