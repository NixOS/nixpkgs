{androidenv, myfirstapp}:

androidenv.emulateApp {
  name = "MyFirstApp";
  app = myfirstapp;
  platformVersion = "16";
  useGoogleAPIs = true;
  package = "com.example.my.first.app";
  activity = "MainActivity";
}
