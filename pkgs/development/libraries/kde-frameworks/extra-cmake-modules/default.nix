{ makeSetupHook, lib, cmake, ecmNoHooks, pkgconfig, qtbase, qttools }:

makeSetupHook {
  deps = lib.chooseDevOutputs [ cmake ecmNoHooks pkgconfig qtbase qttools ];
}
./setup-hook.sh
