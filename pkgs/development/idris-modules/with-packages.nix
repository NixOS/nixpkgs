# Build a version of idris with a set of packages visible
# packages: The packages visible to idris
{ stdenv, idris }: packages: stdenv.mkDerivation {
  inherit (idris) name;

  buildInputs = packages;

  preHook = ''
    mkdir -p $out/lib/${idris.name}

    installIdrisLib () {
      if [ -d $1/lib/${idris.name} ]; then
        ln -fsv $1/lib/${idris.name}/* $out/lib/${idris.name}
      fi
    }

    envHooks+=(installIdrisLib)
  '';

  unpackPhase = ''
    cat >idris.c <<EOF
    #include <stdlib.h>
    #include <unistd.h>
    #include <stdio.h>

    int main (int argc, char ** argv) {
      /* idris currently only supports a single library path, so respect it if the user set it */
      setenv("IDRIS_LIBRARY_PATH", "$out/lib/${idris.name}", 0);
      execv("${idris}/bin/idris", argv);
      perror("executing ${idris}/bin/idris");
      return 127;
    }
    EOF
  '';

  buildPhase = ''
    $CC -O3 -o idris idris.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv idris $out/bin
  '';

  stripAllList = [ "bin" ];
}
