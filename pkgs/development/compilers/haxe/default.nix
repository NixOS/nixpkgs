{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  ocaml-ng,
  dune,
  zlib,
  pcre2,
  neko,
  mbedtls,
}:
let
  ocamlDependencies =
    version: with ocaml-ng.ocamlPackages; [
      ocaml
      findlib
      sedlex
      xml-light
      ptmap
      camlp5
      sha
      luv
      extlib
    ];

  generic =
    {
      hash,
      version,
    }:
    stdenv.mkDerivation {
      pname = "haxe";
      inherit version;

      buildInputs = [
        zlib
        neko
        dune
        pcre2
        mbedtls
      ]
      ++ ocamlDependencies version;

      src = fetchFromGitHub {
        owner = "HaxeFoundation";
        repo = "haxe";
        rev = version;
        fetchSubmodules = true;
        inherit hash;
      };

      prePatch = ''
        substituteInPlace extra/haxelib_src/src/haxelib/client/Main.hx \
          --replace-fail '"neko"' '"${neko}/bin/neko"'
      '';

      buildFlags = [
        "all"
        "tools"
      ];

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

      meta = {
        description = "Programming language targeting JavaScript, Flash, NekoVM, PHP, C++";
        homepage = "https://haxe.org";
        license = with lib.licenses; [
          gpl2Plus
          mit
        ]; # based on upstream opam file
        maintainers = [
          lib.maintainers.locallycompact
          lib.maintainers.logo
          lib.maintainers.bwkam
        ];
        platforms = lib.platforms.linux ++ lib.platforms.darwin;
      };
    };
in
{
  haxe_4_3 = generic {
    version = "4.3.7";
    hash = "sha256-sQb7MCoH2dZOvNmDQ9P0yFYrSXYOMn4FS/jlyjth39Y=";
  };
}
