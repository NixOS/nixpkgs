{ stdenv, idris, packages }: stdenv.mkDerivation {
  inherit (idris) name;

  inherit packages;

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
    gcc -O3 -o idris idris.c
  '';

  installPhase = ''
    mkdir -p $out/lib/${idris.name}
    for package in $packages
    do
      ln -sv $package/lib/${idris.name}/* $out/lib/${idris.name}
    done

    mkdir -p $out/bin
    mv idris $out/bin
  '';

  stripAllList = [ "bin" ];
}
