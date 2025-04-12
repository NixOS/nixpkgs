{
  lib,
  symlinkJoin,
  nmap,
  rockyou,
  seclists,
  wfuzz,
  lists ? [
    nmap
    rockyou
    seclists
    wfuzz
  ],
  writeShellScriptBin,
  tree,
}:
let
  wordlistsCollection = symlinkJoin {
    name = "wordlists-collection";
    paths = lists;

    postBuild = ''
      shopt -s extglob
      rm -rf $out/!(share)
      rm -rf $out/share/!(wordlists)
      shopt -u extglob
    '';
  };

  # A command to show the location of the links.
  wordlistsBin = writeShellScriptBin "wordlists" ''
    ${lib.getExe tree} ${wordlistsCollection}/share/wordlists
  '';
  # A command for easy access to the wordlists.
  wordlistsPathBin = writeShellScriptBin "wordlists_path" ''
    printf "${wordlistsCollection}/share/wordlists\n"
  '';

in
symlinkJoin {
  name = "wordlists";

  paths = [
    wordlistsCollection
    wordlistsBin
    wordlistsPathBin
  ];

  meta = with lib; {
    description = "Collection of wordlists useful for security testing";
    longDescription = ''
      The `wordlists` package provides two scripts. One is called {command}`wordlists`,
      and it will list a tree of all the wordlists installed. The other one is
      called {command}`wordlists_path` which will print the path to the nix store
      location of the lists. You can for example do
      {command}`$(wordlists_path)/rockyou.txt` to get the location of the
      [rockyou](https://en.wikipedia.org/wiki/RockYou#Data_breach)
      wordlist. If you want to modify the available wordlists you can override
      the `lists` attribute`. In your nixos configuration this would look
      similiar to this:

      ```nix
      environment.systemPackages = [
        (pkgs.wordlists.override { lists = with pkgs; [ rockyou ] })
      ]
      ```

      you can use this with nix-shell by doing:
      {command}`nix-shell -p 'wordlists.override { lists = with (import <nixpkgs> {}); [ nmap ]; }'
      If you want to add a new package that provides wordlist/s the convention
      is to copy it to {file}`$out/share/wordlists/myNewWordlist`.
    '';
    maintainers = with maintainers; [
      pamplemousse
      h7x4
    ];
  };
}
