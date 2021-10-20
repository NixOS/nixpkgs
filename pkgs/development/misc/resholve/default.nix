{ callPackage
, writeTextFile
}:

let
  source = callPackage ./source.nix { };
  deps = callPackage ./deps.nix { };
in
rec {
  resholve = callPackage ./resholve.nix {
    inherit (source) rSrc version;
    inherit (deps.oil) oildev;
  };
  resholve-utils = callPackage ./resholve-utils.nix {
    inherit resholve;
  };
  resholvePackage = callPackage ./resholve-package.nix {
    inherit resholve resholve-utils;
  };
  resholveScript = name: partialSolution: text:
    writeTextFile {
      inherit name text;
      executable = true;
      checkPhase = ''
        (
          PS4=$'\x1f'"\033[33m[resholve context]\033[0m "
          set -x
          ${resholve-utils.makeInvocation name (partialSolution // {
            scripts = [ "${placeholder "out"}" ];
          })}
        )
        ${partialSolution.interpreter} -n $out
      '';
    };
  resholveScriptBin = name: partialSolution: text:
    writeTextFile rec {
      inherit name text;
      executable = true;
      destination = "/bin/${name}";
      checkPhase = ''
        (
          cd "$out"
          PS4=$'\x1f'"\033[33m[resholve context]\033[0m "
          set -x
          : changing directory to $PWD
          ${resholve-utils.makeInvocation name (partialSolution // {
            scripts = [ "bin/${name}" ];
          })}
        )
        ${partialSolution.interpreter} -n $out/bin/${name}
      '';
    };
}
