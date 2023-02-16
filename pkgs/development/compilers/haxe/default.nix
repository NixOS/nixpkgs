{ lib, stdenv, fetchFromGitHub, coreutils, ocaml-ng, zlib, pcre, neko, mbedtls_2, Security }:

let
  ocamlDependencies = version:
    if lib.versionAtLeast version "4.2"
    then with ocaml-ng.ocamlPackages_4_12; [
      ocaml
      findlib
      sedlex
      xml-light
      ptmap
      camlp5
      sha
      dune_3
      luv
      extlib
    ] else if lib.versionAtLeast version "4.0"
    then with ocaml-ng.ocamlPackages_4_10; [
      ocaml
      findlib
      sedlex
      xml-light
      ptmap
      camlp5
      sha
      dune_3
      luv
      extlib-1-7-7
    ] else with ocaml-ng.ocamlPackages_4_05; [
      ocaml
      camlp4
    ];

  defaultPatch = ''
    substituteInPlace extra/haxelib_src/src/haxelib/client/Main.hx \
      --replace '"neko"' '"${neko}/bin/neko"'
  '';

  generic = { sha256, version, prePatch ? defaultPatch }:
    stdenv.mkDerivation {
      pname = "haxe";
      inherit version;

      buildInputs = [ zlib pcre neko ]
        ++ lib.optional (lib.versionAtLeast version "4.1") mbedtls_2
        ++ lib.optional (lib.versionAtLeast version "4.1" && stdenv.isDarwin) Security
        ++ ocamlDependencies version;

      src = fetchFromGitHub {
        owner = "HaxeFoundation";
        repo = "haxe";
        rev = version;
        fetchSubmodules = true;
        inherit sha256;
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
        license = with licenses; [ gpl2Plus mit ]; # based on upstream opam file
        maintainers = [ maintainers.marcweber maintainers.locallycompact maintainers.logo ];
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
      substituteInPlace extra/haxelib_src/src/tools/haxelib/Main.hx \
        --replace '"neko"' '"${neko}/bin/neko"'
    '';
  };
  haxe_3_4 = generic {
    version = "3.4.6";
    sha256 = "1myc4b8fwp0f9vky17wv45n34a583f5sjvajsc93f5gm1wanp4if";
    prePatch = ''
      ${defaultPatch}
      sed -i -re 's!(let +prefix_path += +).*( +in)!\1"'"$out/"'"\2!' src/main.ml
    '';
  };
  haxe_4_0 = generic {
    version = "4.0.5";
    sha256 = "0f534pchdx0m057ixnk07ab4s518ica958pvpd0vfjsrxg5yjkqa";
  };
  haxe_4_1 = generic {
    version = "4.1.5";
    sha256 = "0rns6d28qzkbai6yyws08yzbyvxfn848nj0fsji7chdi0y7pzzj0";
  };
  haxe_4_2 = generic {
    version = "4.2.5";
    sha256 = "sha256-Y0gx6uOQX4OZgg8nK4GJxRR1rKh0S2JUjZQFVQ4cfTs=";
  };
}
