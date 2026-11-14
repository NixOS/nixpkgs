{
  lib,
  writeShellApplication,
  xorg,
  makeSetupHook,

  makeWrapper,
}:
makeSetupHook {
  name = "writable-dir-wrapper";

  propagatedBuildInputs = [
    makeWrapper
  ];

  substitutions = {
    lndir = lib.getExe xorg.lndir;
  };

} ./wrapper.sh

/**
  A wrapper for programs that require a writable directory to function, typically
  games or proprietary software that expect read-only resources to be placed alongside
  config files and state files (e.g. logs).

  # Inputs

  *`options`* (Attribute set)

  : Set of options for the wrapper.

    `name` (String)

    : File name of the wrapper.

   `version` (String, _optional_)

    : Version of the underlying program. When set, version checks will be enabled and existing links will be recreated if they belong to a different version.

    `path` (String)

    : Path of the directory that would hold the linked data.

    `links` (List of attrsets, _optional_)

    : List of links from a source directory to a directory relative to the output path.

      `src` (String)

      : Source directory of the link, usually from the Nix store.

      `dst` (String, _optional_)

      : Destination directory of the link.

      : _Default:_ the output path.

    `postLink` (String, _optional_)

    : Command to run after (re-)linking. Since links are first created in a temporary directory, `postLink` can be used to remove or add files that will be copied to the output path (for example, when some files need to be excluded from the linked result).

    `exec` (String)

    : Command to run.

    `flags` (List of strings, _optional_)

    : The list of flags given to the command. ***Unescaped and can refer to Bash variables and perform shell substitutions.***

  # Type

  ```
  writableDirWrapper ::
    {
      name :: String;
      version? :: String;
      path :: String;
      links? :: [{ src :: String; dst? :: String }];
      postLink? :: String;
      exec :: String
    } -> Derivation
  ```

  # Examples
  :::{.example}
  ## `pkgs.writableDirWrapper` usage example

  ```nix
  {
    writableDirWrapper,
    hello,
  }:
  writableDirWrapper {
    name = "writable-hello";
    links = [
      {
        src = hello;
        dst = "hello";
      }
    ];
    postLink = ''
      echo "Hello world!" | base64 > hello.txt
    '';
    exec = ''
      ./hello/bin/hello --greeting=$(<"hello.txt")
    '';
  }
  ```

  When built and run, this should output:
  ```console
  SGVsbG8gd29ybGQhCg==
  ```
  :::
*/
