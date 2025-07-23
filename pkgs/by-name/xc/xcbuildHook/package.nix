{ makeSetupHook, xcbuild }:

makeSetupHook {
  name = "xcbuild-hook";
  propagatedBuildInputs = [ xcbuild ];
} ./hook.sh
