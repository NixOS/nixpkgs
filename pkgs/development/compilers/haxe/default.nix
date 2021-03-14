{ lib, stdenv, fetchgit, coreutils, ocaml-ng, zlib, pcre, neko, mbedtls }:

let
  generic = { version, sha256, buildInputs, prePatch }:
    stdenv.mkDerivation {
      pname = "haxe";
      inherit version buildInputs prePatch;

      src = fetchgit {
        url = "https://github.com/HaxeFoundation/haxe.git";
        inherit sha256;
        fetchSubmodules = true;
        rev = "refs/tags/${version}";
      };

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

      # While it might be a good idea to run the upstream test suite, let's at
      # least make sure we can actually run the compiler.
      doInstallCheck = true;
      installCheckPhase = ''
        # Get out of the source directory to make sure the stdlib from the
        # sources doesn't interfere with the installed one.
        mkdir installcheck
        pushd installcheck > /dev/null
        cat >> InstallCheck.hx <<EOF
        class InstallCheck {
          public static function main() trace("test");
        }
        EOF
        "$out/bin/haxe" -js installcheck.js -main InstallCheck
        grep -q 'console\.log.*test' installcheck.js
        popd > /dev/null
      '';

      meta = with lib; {
        description = "Programming language targeting JavaScript, Flash, NekoVM, PHP, C++";
        homepage = "https://haxe.org";
        license = with licenses; [ gpl2 bsd2 /*?*/ ];  # -> docs/license.txt
        maintainers = [ maintainers.locallycompact ];
        platforms = platforms.linux ++ platforms.darwin;
      };
    };
in {
  haxe_4_2 = generic {
    version = "4.2.1";
    sha256 = "sha256-0j6M21dh8DB1gC/bPYNJrVuDbJyqQbP+61ItO5RBUcA=";
    buildInputs = [zlib pcre neko mbedtls] ++ (with ocaml-ng.ocamlPackages_4_10; [ocaml findlib sedlex_2 xml-light ptmap camlp5 sha ocaml_extlib dune_2 luv]);
    prePatch = ''
      sed -i -e 's|"neko"|"${neko}/bin/neko"|g' extra/haxelib_src/src/haxelib/client/Main.hx
    '';
  };
}
