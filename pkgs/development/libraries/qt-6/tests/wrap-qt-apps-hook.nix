{
  lib,
  qtbase,
  runCommandLocal,
  stdenv,
  wrapQtAppsHook,
}:
let
  testProgram = stdenv.mkDerivation {
    pname = "qt-wrapper-test-program";
    version = "0.0.1";
    __structuredAttrs = true;

    dontUnpack = true;

    src = /* c */ ''
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>

      int main(void) {
          const char *wrapperTest = getenv("WRAPPER_TEST");
          if (!wrapperTest || strcmp(wrapperTest, "expected") != 0) {
              fprintf(stderr,
                      "expected WRAPPER_TEST=expected, got=%s\n",
                      wrapperTest);
              return 1;
          }

          const char *plugin_path = getenv("QT_PLUGIN_PATH");
          if (!plugin_path) {
              fprintf(stderr, "QT_PLUGIN_PATH not set\n");
              return 1;
          }

          if (!strstr(plugin_path,
                      "${qtbase}/${qtbase.qtPluginPrefix}")) {
              fprintf(stderr,
                      "QT_PLUGIN_PATH missing Qt plugin dir:\n%s\n",
                      plugin_path);
              return 1;
          }

          return 0;
      }
    '';

    buildPhase = ''
      "$CC" -x c - -o test <<<"$src"
    '';

    installPhase = ''
      mkdir -p $out/bin
      install -m755 test $out/bin/test
    '';

    meta.mainProgram = "test";
  };

  # Test that wrapQtAppsHook produces the expected qtWrapperArgs bash array
  checkWrapperArgsArray =
    {
      name,
      qtWrapperArgs,
    }:
    runCommandLocal "${name}-check-qtWrapperArgs"
      {
        inherit qtWrapperArgs;
        buildInputs = [ qtbase ];
        nativeBuildInputs = [ wrapQtAppsHook ];
        __structuredAttrs = true;
      }
      ''
        ${lib.toShellVars {
          # The resulting array should start with the exact user-defined args:
          userDefinedArgs = qtWrapperArgs;

          # The hook's setup should also add internal flags, including:
          internalArgs = [
            "QT_PLUGIN_PATH"
            "${qtbase}/${qtbase.qtPluginPrefix}"
          ];
        }}

        # The hook should have run its setup already, converting qtWrapperArgs
        # to an array and appending internal flags.
        type=$(declare -p qtWrapperArgs)
        [[ "$type" == "declare -"*a* ]] || {
          echo "Expected qtWrapperArgs to be an array, found: ''${type%%=*}" >&2
          exit 1
        }

        # The start of the array should equal the user-defined args
        for i in "''${!userDefinedArgs[@]}"; do
          actual="''${qtWrapperArgs[$i]}"
          expected="''${userDefinedArgs[$i]}"
          [ "$expected" = "$actual" ] || {
            echo "qtWrapperArgs[$i]: expected '$expected', found '$actual'" >&2
            exit 1
          }
        done

        # Internal args should be appended to the array
        internalSlice=("''${qtWrapperArgs[@]:''${#userDefinedArgs[@]}}")
        for expected in "''${internalArgs[@]}"; do
          found=
          for actual in "''${internalSlice[@]}"; do
            if [ "$expected" = "$actual" ]; then
              found=1
              break
            fi
          done

          [ -n "$found" ] || {
            echo "Internal arg '$expected' not found in internal qtWrapperArgs" >&2
            exit 1
          }
        done

        # The hook should've defined the wrapQtAppsHook function
        [ "$(type -t wrapQtAppsHook)" = function ] || {
          echo "wrapQtAppsHook is not declared as a function" >&2
          exit 1
        }

        touch "$out"
      '';
in

lib.fix (self: {

  simple = checkWrapperArgsArray {
    name = "simple";
    qtWrapperArgs = [
      "--chdir"
      "/foo"
    ];
  };

  simple-no-structuredAttrs = self.simple.overrideAttrs (prevAttrs: {
    name = prevAttrs.name + "-no-structuredAttrs";
    __structuredAttrs = false;
  });

  # Integration test: assert program is wrapped with the expected environment
  runtime =
    runCommandLocal "simple-wrapper-runtime"
      {
        qtWrapperArgs = [
          "--set"
          "WRAPPER_TEST"
          "expected"
        ];

        buildInputs = [ qtbase ];
        nativeBuildInputs = [ wrapQtAppsHook ];
        __structuredAttrs = true;
      }
      ''
        # Install the test program
        mkdir -p "$out/bin"
        cp ${lib.getExe testProgram} "$out/bin/test"

        # Wrap and run the test
        wrapQtAppsHook
        "$out/bin/test"
      '';

  runtime-no-structuredAttrs = self.runtime.overrideAttrs (prevAttrs: {
    name = prevAttrs.name + "-no-structuredAttrs";
    __structuredAttrs = false;
  });

})
