{
  lib,
}:

/*
  This is a set of tools to manipulate update scripts as recognized by update.nix.
  It is still very experimental with **instability** almost guaranteed so any use
  outside Nixpkgs is discouraged.

  update.nix currently accepts the following type:

  type UpdateScript
    // Simple path to script to execute script
    = FilePath
    // Path to execute plus arguments to pass it
    | [ (FilePath | String) ]
    // Advanced attribue set (experimental)
    | {
      // Script to execute (same as basic update script above)
      command : (FilePath | [ (FilePath | String) ])
      // Features that the script supports
      // - commit: (experimental) returns commit message in stdout
      // - silent: (experimental) returns no stdout
      supportedFeatures : ?[ ("commit" | "silent") ]
      // Override attribute path detected by update.nix
      attrPath : ?String
    }
*/

let
  # type ShellArg = String | { __rawShell : String }

  /*
    Quotes all arguments to be safely passed to the Bourne shell.

    escapeShellArgs' : [ShellArg] -> String
  */
  escapeShellArgs' = lib.concatMapStringsSep " " (
    arg: if arg ? __rawShell then arg.__rawShell else lib.escapeShellArg arg
  );

  /*
    processArg : { maxArgIndex : Int, args : [ShellArg], paths : [FilePath] } → (String|FilePath) → { maxArgIndex : Int, args : [ShellArg], paths : [FilePath] }
    Helper reducer function for building a command arguments where file paths are replaced with argv[x] reference.
  */
  processArg =
    {
      maxArgIndex,
      args,
      paths,
    }:
    arg:
    if builtins.isPath arg then
      {
        args = args ++ [ { __rawShell = "\"\$${builtins.toString maxArgIndex}\""; } ];
        maxArgIndex = maxArgIndex + 1;
        paths = paths ++ [ arg ];
      }
    else
      {
        args = args ++ [ arg ];
        inherit maxArgIndex paths;
      };
  /*
    extractPaths : Int → [ (String|FilePath) ] → { maxArgIndex : Int, args : [ShellArg], paths : [FilePath] }
    Helper function that extracts file paths from command arguments and replaces them with argv[x] references.
  */
  extractPaths =
    maxArgIndex: command:
    builtins.foldl' processArg {
      inherit maxArgIndex;
      args = [ ];
      paths = [ ];
    } command;
  /*
    processCommand : { maxArgIndex : Int, commands : [[ShellArg]], paths : [FilePath] } → [ (String|FilePath) ] → { maxArgIndex : Int, commands : [[ShellArg]], paths : [FilePath] }
    Helper reducer function for extracting file paths from individual commands.
  */
  processCommand =
    {
      maxArgIndex,
      commands,
      paths,
    }:
    command:
    let
      new = extractPaths maxArgIndex command;
    in
    {
      commands = commands ++ [ new.args ];
      paths = paths ++ new.paths;
      maxArgIndex = new.maxArgIndex;
    };
  /*
    extractCommands : Int → [[ (String|FilePath) ]] → { maxArgIndex : Int, commands : [[ShellArg]], paths : [FilePath] }
    Helper function for extracting file paths from a list of commands and replacing them with argv[x] references.
  */
  extractCommands =
    maxArgIndex: commands:
    builtins.foldl' processCommand {
      inherit maxArgIndex;
      commands = [ ];
      paths = [ ];
    } commands;

  /*
    commandsToShellInvocation : [[ (String|FilePath) ]] → [ (String|FilePath) ]
    Converts a list of commands into a single command by turning them into a shell script and passing them to `sh -c`.
  */
  commandsToShellInvocation =
    commands:
    let
      extracted = extractCommands 0 commands;
    in
    [
      "sh"
      "-c"
      (lib.concatMapStringsSep ";" escapeShellArgs' extracted.commands)
      # We need paths as separate arguments so that update.nix can ensure they refer to the local directory
      # rather than a store path.
    ]
    ++ extracted.paths;
in
rec {
  /*
    normalize : UpdateScript → UpdateScript
    EXPERIMENTAL! Converts a basic update script to the experimental attribute set form.
  */
  normalize =
    updateScript:
    {
      command = lib.toList (updateScript.command or updateScript);
      supportedFeatures = updateScript.supportedFeatures or [ ];
    }
    // lib.optionalAttrs (updateScript ? attrPath) {
      inherit (updateScript) attrPath;
    };

  /*
    sequence : [UpdateScript] → UpdateScript
    EXPERIMENTAL! Combines multiple update scripts to run in sequence.
  */
  sequence =
    scripts:

    let
      scriptsNormalized = builtins.map normalize scripts;
    in
    let
      scripts = scriptsNormalized;
      hasCommitSupport =
        lib.findSingle ({ supportedFeatures, ... }: supportedFeatures == [ "commit" ]) null null scripts
        != null;
      validateFeatures =
        if hasCommitSupport then
          ({ supportedFeatures, ... }: supportedFeatures == [ "commit" ] || supportedFeatures == [ "silent" ])
        else
          ({ supportedFeatures, ... }: supportedFeatures == [ ]);
    in

    assert lib.assertMsg (lib.all validateFeatures scripts)
      "Combining update scripts with features enabled (other than a single script with “commit” and all other with “silent”) is currently unsupported.";
    assert lib.assertMsg (
      builtins.length (
        lib.unique (
          builtins.map (
            {
              attrPath ? null,
              ...
            }:
            attrPath
          ) scripts
        )
      ) == 1
    ) "Combining update scripts with different attr paths is currently unsupported.";

    {
      command = commandsToShellInvocation (builtins.map ({ command, ... }: command) scripts);
      supportedFeatures = lib.optionals hasCommitSupport [
        "commit"
      ];
    };

  /*
    copyAttrOutputToFile : String → FilePath → UpdateScript
    EXPERIMENTAL! Simple update script that copies the output of Nix derivation built by `attr` to `path`.
  */
  copyAttrOutputToFile =
    attr: path:

    {
      command = [
        "sh"
        "-c"
        "cp --no-preserve=all \"$(nix-build -A ${attr})\" \"$0\" > /dev/null"
        path
      ];
      supportedFeatures = [ "silent" ];
    };

}
