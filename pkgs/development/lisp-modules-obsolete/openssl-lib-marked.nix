with import ../../../default.nix {};
runCommand "openssl-lib-marked" {} ''
  mkdir -p "$out/lib"
  for lib in ssl crypto; do
    version="${lib.getVersion openssl}"
    ln -s "${lib.getLib openssl}/lib/lib$lib.so" "$out/lib/lib$lib.so.$version"
    version="$(echo "$version" | sed -re 's/[a-z]+$//')"
    while test -n "$version"; do
      ln -sfT "${lib.getLib openssl}/lib/lib$lib.so" "$out/lib/lib$lib.so.$version"
      nextversion="''${version%.*}"
      if test "$version" = "$nextversion"; then
        version=
      else
        version="$nextversion"
      fi
    done
  done
''
