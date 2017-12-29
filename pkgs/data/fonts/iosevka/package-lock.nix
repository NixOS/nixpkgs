{ lib, fetchurl }:

with lib; with builtins;

let
  # Convert a base64-encoded string into a list of quads and padding.
  fromBase64 = str:
    let
      len = stringLength str;
      quads = 3 * len - 4 * padding;
      padding =
        if hasSuffix "==" str then 2 else
        if hasSuffix "=" str then 1 else
        0;
      chars = stringToCharacters (substring 0 (len - padding) str);
      table = {
        "A" = [0 0 0];
        "B" = [0 0 1];
        "C" = [0 0 2];
        "D" = [0 0 3];
        "E" = [0 1 0];
        "F" = [0 1 1];
        "G" = [0 1 2];
        "H" = [0 1 3];
        "I" = [0 2 0];
        "J" = [0 2 1];
        "K" = [0 2 2];
        "L" = [0 2 3];
        "M" = [0 3 0];
        "N" = [0 3 1];
        "O" = [0 3 2];
        "P" = [0 3 3];
        "Q" = [1 0 0];
        "R" = [1 0 1];
        "S" = [1 0 2];
        "T" = [1 0 3];
        "U" = [1 1 0];
        "V" = [1 1 1];
        "W" = [1 1 2];
        "X" = [1 1 3];
        "Y" = [1 2 0];
        "Z" = [1 2 1];
        "a" = [1 2 2];
        "b" = [1 2 3];
        "c" = [1 3 0];
        "d" = [1 3 1];
        "e" = [1 3 2];
        "f" = [1 3 3];
        "g" = [2 0 0];
        "h" = [2 0 1];
        "i" = [2 0 2];
        "j" = [2 0 3];
        "k" = [2 1 0];
        "l" = [2 1 1];
        "m" = [2 1 2];
        "n" = [2 1 3];
        "o" = [2 2 0];
        "p" = [2 2 1];
        "q" = [2 2 2];
        "r" = [2 2 3];
        "s" = [2 3 0];
        "t" = [2 3 1];
        "u" = [2 3 2];
        "v" = [2 3 3];
        "w" = [3 0 0];
        "x" = [3 0 1];
        "y" = [3 0 2];
        "z" = [3 0 3];
        "0" = [3 1 0];
        "1" = [3 1 1];
        "2" = [3 1 2];
        "3" = [3 1 3];
        "4" = [3 2 0];
        "5" = [3 2 1];
        "6" = [3 2 2];
        "7" = [3 2 3];
        "8" = [3 3 0];
        "9" = [3 3 1];
        "+" = [3 3 2];
        "/" = [3 3 3];
      };
    in
      take quads (concatMap (c: table.${c}) chars);

  # Convert a list of quads with padding into a base16-encoded string.
  toBase16 = quads:
    if length quads == 0 then "" else
    if length quads == 1 then throw "toBase16: odd quads" else
    let
      hexad = 4 * elemAt quads 0 + elemAt quads 1;
      hexits = "0123456789abcdef";
    in
      substring hexad 1 hexits + toBase16 (drop 2 quads);
in

let
  fetchResolved = { resolved, integrity, ... }:
    let args = { url = resolved; } // integrityHash integrity; in
      fetchurl args;
  integrityHash = integrity:
    if hasPrefix "sha1-" integrity then integritySHA1 integrity else
    if hasPrefix "sha512-" integrity then integritySHA512 integrity else
    throw "don't understand integrity: ${integrity}";
  integritySHA1 = integrity:
    { sha1 = toBase16 (fromBase64 (removePrefix "sha1-" integrity)); };
  integritySHA512 = integrity:
    { sha512 = toBase16 (fromBase64 (removePrefix "sha512-" integrity)); };
in

let
  depend = name: attrs@{ version, dependencies ? {}, ... }:
      {
        inherit name version;
        src = fetchResolved attrs;
        depends = mapAttrsToList depend dependencies;
      };
  prepareDepend = { name, src, depends, ... }:
    ''
      unpackFile '${src}'
      mv package '${name}'
      mkdir -p '${name}/node_modules'
      (
          cd '${name}/node_modules'
          ${concatMapStrings prepareDepend depends}
      )
    '';
in

packageLockFile:

let
  packageLock = fromJSON (readFile packageLockFile);
  depends = mapAttrsToList depend packageLock.dependencies;
in
  ''
    mkdir -p node_modules
    (
        cd node_modules
        ${concatMapStrings prepareDepend depends}
    )
  ''

