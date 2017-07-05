{ stdenv, fetchgit, bash, coreutils, ocaml, zlib, pcre, neko, camlp4 }:

let
  generic = { version, sha256, prePatch }:
    stdenv.mkDerivation rec {
      name = "haxe-${version}";

      buildInputs = [ocaml zlib pcre neko camlp4];

      src = fetchgit {
        url = https://github.com/HaxeFoundation/haxe.git;
        inherit sha256;
        fetchSubmodules = true;
        rev = "refs/tags/${version}";
      };

      inherit prePatch;

      buildFlags = [ "all" "tools" ];

      installPhase = ''
        install -vd "$out/bin" "$out/lib/haxe/std"
        cp -vr haxe haxelib std "$out/lib/haxe"

        # make wrappers which provide a temporary HAXELIB_PATH with symlinks to multiple repositories HAXELIB_PATH may point to
        for name in haxe haxelib; do
        cat > $out/bin/$name <<EOF
        #!{bash}/bin/bash

        if [[ "\$HAXELIB_PATH" =~ : ]]; then
          NEW_HAXELIB_PATH="\$(${coreutils}/bin/mktemp -d)"

          IFS=':' read -ra libs <<< "\$HAXELIB_PATH"
          for libdir in "\''${libs[@]}"; do
            for lib in "\$libdir"/*; do
              if [ ! -e "\$NEW_HAXELIB_PATH/\$(${coreutils}/bin/basename "\$lib")" ]; then
                ${coreutils}/bin/ln -s "--target-directory=\$NEW_HAXELIB_PATH" "\$lib"
              fi
            done
          done
          export HAXELIB_PATH="\$NEW_HAXELIB_PATH"
          $out/lib/haxe/$name "\$@"
          rm -rf "\$NEW_HAXELIB_PATH"
        else
          exec $out/lib/haxe/$name "\$@"
        fi
        EOF
        chmod +x $out/bin/$name
        done
      '';

      setupHook = ./setup-hook.sh;

      dontStrip = true;

      meta = with stdenv.lib; {
        description = "Programming language targeting JavaScript, Flash, NekoVM, PHP, C++";
        homepage = https://haxe.org;
        license = with licenses; [ gpl2 bsd2 /*?*/ ];  # -> docs/license.txt
        maintainers = [ maintainers.marcweber ];
        platforms = platforms.linux ++ platforms.darwin;
      };
    };
in {
  # this old version is required to compile some libraries
  haxe_3_2 = generic {
    version = "3.2.1";
    sha256 = "1x9ay5a2llq46fww3k07jxx8h1vfpyxb522snc6702a050ki5vz3";
    prePatch = ''
      sed -i -e 's|"/usr/lib/haxe/std/";|"'"$out/lib/haxe/std/"'";\n&|g' main.ml
      sed -i -e 's|"neko"|"${neko}/bin/neko"|g' extra/haxelib_src/src/tools/haxelib/Main.hx
    '';
  };
  haxe_3_4 = generic {
    version = "3.4.2";
    sha256 = "1m5fp183agqv8h3ynhxw4kndkpq2d6arysmirv3zl3vz5crmpwqd";
    prePatch = ''
      sed -i -e 's|"/usr/lib/haxe/std/";|"'"$out/lib/haxe/std/"'";\n&|g' src/main.ml
      sed -i -e 's|"neko"|"${neko}/bin/neko"|g' extra/haxelib_src/src/haxelib/client/Main.hx
    '';
  };
}
