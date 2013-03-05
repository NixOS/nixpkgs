{xcodeenv, kitchensink, device}:

xcodeenv.simulateApp {
  name = "kitchensink";
  app = kitchensink;
  inherit device;
  baseDir = "build/iphone/build/Debug-iphonesimulator";
}
