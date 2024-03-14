
let
  pkgs = import ../../../default.nix {};

  inherit (pkgs) openssl runCommand;
  inherit (pkgs.lib) getLib getVersion;
in

runCommand "openssl-lib-marked" {} ''
  mkdir -p "$out/lib"
  for lib in ssl crypto; do
    version="${getVersion openssl}"
    ln -s "${getLib openssl}/lib/lib$lib.so" "$out/lib/lib$lib.so.$version"
    version="$(echo "$version" | sed -re 's/[a-z]+$//')"
    while test -n "$version"; do
      ln -sfT "${getLib openssl}/lib/lib$lib.so" "$out/lib/lib$lib.so.$version"
      nextversion="''${version%.*}"
      if test "$version" = "$nextversion"; then
        version=
      else
        version="$nextversion"
      fi
    done
  done
''
