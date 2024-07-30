{ makeSetupHook
, teensy-cmake-macros
}:

makeSetupHook {
  name = "teensy-cmake-macros-hook";

  propagatedBuildInputs = [ teensy-cmake-macros ];

  passthru = { inherit teensy-cmake-macros; };

  meta = {
    description = "Setup hook for teensy-cmake-macros";
    inherit (teensy-cmake-macros.meta) maintainers platforms broken;
  };
} ./setup-hook.sh
