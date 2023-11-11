{ lib
, callPackage
, nmap
, rockyou
, runtimeShell
, seclists
, symlinkJoin
, tree
, wfuzz
, lists ? [
    nmap
    rockyou
    seclists
    wfuzz
  ]
}:

symlinkJoin rec {
  pname = "wordlists";
  version = "unstable-2023-10-10";

  name = "${pname}-${version}";
  paths = lists;

  postBuild = ''
    mkdir -p $out/bin

    # Create a command to show the location of the links.
    cat >> $out/bin/wordlists << __EOF__
    #!${runtimeShell}
    ${tree}/bin/tree ${placeholder "out"}/share/wordlists
    __EOF__
    chmod +x $out/bin/wordlists

    # Create a handy command for easy access to the wordlists.
    # e.g.: `cat "$(wordlists_path)/rockyou.txt"`, or `ls "$(wordlists_path)/dirbuster"`
    cat >> $out/bin/wordlists_path << __EOF__
    #!${runtimeShell}
    printf "${placeholder "out"}/share/wordlists\n"
    __EOF__
    chmod +x $out/bin/wordlists_path
  '';

  meta = with lib; {
    description = "A collection of wordlists useful for security testing";
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
    maintainers = with maintainers; [ janik pamplemousse ];
  };
}
