{ lib
, pkgs
}:

rec {

  # A selection of j2cli-based builders.
  # These builders largely follow the format of pkgs.writeText{,File,Dir}

  generateFile =
    args_@{ name # derivation name
          , data # j2cli data
          , template  # j2cli template
          , destination ? "" # $out suffix
          , executable ? false # whether result is marked executable
          , ...
          }:
    let
      args = builtins.removeAttrs args_ [ "name" "data" "template" "destination" "executable" ];

      dataFile = (pkgs.formats.json { }).generate "${name}-data.json" data;

      templateFile = pkgs.writeText "${name}-template.j2" template;

      dest = lib.escapeShellArg "${destination}";

    in pkgs.runCommand name args ''
      ${lib.optionalString (destination != "") ''
        mkdir -p "$( dirname "$out"${dest} )"
      ''}

      ${pkgs.j2cli}/bin/j2 ${templateFile} ${dataFile} -f json -o "$out"${destination}

      ${lib.optionalString executable ''
        chmod +x "$out"${destination}
      ''}
    '';


  # simpler version

  generate = name: data: template:
    generateFile { inherit name data template; };


  # simple version inside a directory

  generateDir = name: data: template:
    generateFile {
      inherit name data template;
      destination = "/${name}";
    };


  # executable version

  generateScript = name: data: template:
    generateFile {
      inherit name data template;
      executable = true;
    };


  # executable version inside /bin

  generateScriptBin = name: data: template:
    generateFile {
      inherit name data template;
      executable = true;
      destination = "/bin/${name}";
    };

}
