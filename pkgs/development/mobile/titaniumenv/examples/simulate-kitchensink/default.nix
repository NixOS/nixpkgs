{xcodeenv, kitchensink, bundleId}:

xcodeenv.simulateApp {
  name = "simulate-${kitchensink.name}";
  inherit bundleId;
  app = "${kitchensink}/build/iphone/build/Products/Debug-iphonesimulator";
}
