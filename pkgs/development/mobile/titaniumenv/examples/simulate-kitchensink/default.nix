{stdenv, xcodeenv, kitchensink, device}:

xcodeenv.simulateApp {
  name = "simulate-${kitchensink.name}-${stdenv.lib.replaceChars [" " "(" ")"] ["_" "" ""] device}";
  appName = "KitchenSink";
  app = kitchensink;
  inherit device;
  baseDir = "build/iphone/build/Debug-iphonesimulator";
}
