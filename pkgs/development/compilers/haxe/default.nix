args: with args;

let

    src_haxe_swflib = {
      # REGION AUTO UPDATE:                             { name = "haxe_swflib"; type="cvs"; cvsRoot = ":pserver:anonymous@cvs.motion-twin.com:/cvsroot"; module = "ocaml/swflib"; groups = "haxe_group"; }
      src = sourceFromHead "haxe_swflib-F_23-45-43.tar.gz"
                   (fetchurl { url = "http://mawercer.de/~nix/repos/haxe_swflib-F_23-45-43.tar.gz"; sha256 = "a77ce2dda48d28f82b48b96f71404edbf7f58e4c3058b425a473c08d260e0816"; });
      # END
    }.src;

    src_haxe_extc = { 
      # REGION AUTO UPDATE:                             { name = "haxe_extc"; type="cvs"; cvsRoot = ":pserver:anonymous@cvs.motion-twin.com:/cvsroot"; module = "ocaml/extc"; groups = "haxe_group"; }
      src = sourceFromHead "haxe_extc-F_23-45-44.tar.gz"
                   (fetchurl { url = "http://mawercer.de/~nix/repos/haxe_extc-F_23-45-44.tar.gz"; sha256 = "dd49eb771d52f4d67ca1ebdab1ced9a251dc5799f91896c33bd234690997820f"; });
      # END
    }.src;

    src_haxe_extlib_dev = { 
      # REGION AUTO UPDATE:                             { name = "haxe_extlib_dev"; type="cvs"; cvsRoot = ":pserver:anonymous@cvs.motion-twin.com:/cvsroot"; module = "ocaml/extlib-dev"; groups = "haxe_group"; }
      src = sourceFromHead "haxe_extlib_dev-F_23-45-46.tar.gz"
                   (fetchurl { url = "http://mawercer.de/~nix/repos/haxe_extlib_dev-F_23-45-46.tar.gz"; sha256 = "0a3566b6119de9063441cecd553248f3bfc00360edd7143f13b3ab0dbc57b310"; });
      # END
    }.src;

    src_haxe_xml_light = { 
      # REGION AUTO UPDATE:                             { name = "haxe_xml_light"; type="cvs"; cvsRoot = ":pserver:anonymous@cvs.motion-twin.com:/cvsroot"; module = "ocaml/xml-light"; groups = "haxe_group"; }
      src = sourceFromHead "haxe_xml_light-F_23-45-47.tar.gz"
                   (fetchurl { url = "http://mawercer.de/~nix/repos/haxe_xml_light-F_23-45-47.tar.gz"; sha256 = "8e1b5a7f1afcb7a6cd8bcac794c3714305ce94a98e989ccf23a38defb6205ed2"; });
      # END
    }.src;

    src_haxe_neko_include = { 
      # REGION AUTO UPDATE:                             { name = "haxe_neko_include"; type="cvs"; cvsRoot = ":pserver:anonymous@cvs.motion-twin.com:/cvsroot"; module = "neko/libs/include/ocaml"; groups = "haxe_group"; }
      src = sourceFromHead "haxe_neko_include-F_23-45-48.tar.gz"
                   (fetchurl { url = "http://mawercer.de/~nix/repos/haxe_neko_include-F_23-45-48.tar.gz"; sha256 = "78441ec5a20f25c751afeb46e0ea61db6350794f6c5959264059914682c521a9"; });
      # END
    }.src;

    src_haxe = {
      # REGION AUTO UPDATE:    { name="haxe-read-only"; type="svn"; url="http://haxe.googlecode.com/svn/trunk"; groups = "haxe_group"; }
      src = sourceFromHead "haxe-read-only-3207.tar.gz"
                   (fetchurl { url = "http://mawercer.de/~nix/repos/haxe-read-only-3207.tar.gz"; sha256 = "2d315ca69fac69674eb562e1349fdebefb0dca4a91eb4ee28371230aaaf60df1"; });
      # END
    }.src;


    # the HaXe compiler
    haxe = stdenv.mkDerivation {
      name = "haxe-cvs";

      buildInputs = [ocaml zlib makeWrapper];

      src = src_haxe;

      inherit zlib;

      buildPhase = ''
        mkdir -p ocaml/{swflib,extc,extlib-dev,xml-light} neko/libs

        # strange setup. install.ml seems to co the same repo again into haxe directory!
        tar xfz $src --strip-components=1 -C haxe

        t(){ tar xfz $1 -C $2 --strip-components=2; }
        t ${src_haxe_swflib} ocaml/swflib
        t ${src_haxe_extc} ocaml/extc
        t ${src_haxe_extlib_dev} ocaml/extlib-dev
        t ${src_haxe_xml_light} ocaml/xml-light
        t ${src_haxe_neko_include} neko/libs

        sed -e '/download();/d' \
            -e "s@/usr/lib/@''${zlib}/lib/@g" \
            doc/install.ml > install.ml
        
        ocaml install.ml
      '';

      # probably rpath should be set properly
      installPhase = ''
        ensureDir $out/lib/haxe
        cp -r bin $out/bin
        wrapProgram "$out/bin/haxe" \
          --set "LD_LIBRARY_PATH" $zlib/lib \
          --set HAXE_LIBRARY_PATH "''${HAXE_LIBRARY_PATH}''${HAXE_LIBRARY_PATH:-:}:$out/lib/haxe/std:."
        cp -r std $out/lib/haxe/
      '';

      meta = { 
        description = "programming language targeting JavaScript, Flash, NekVM, PHP, C++";
        homepage = http://haxe.org;
        license = ["GPLv2" "BSD2" /*?*/ ];  # -> docs/license.txt
        maintainers = [args.lib.maintainers.marcweber];
        platforms = args.lib.platforms.linux;
      };
    };

    # build a tool found in std/tools/${name} source directory
    # the .hxml files contain a recipe  to cerate a binary.
    tool = { name, description }: stdenv.mkDerivation {

        inherit name;

        src = src_haxe;

        buildPhase = ''
          cd std/tools/${name};
          haxe *.hxml
          ensureDir $out/bin
          mv ${name} $out/bin/
        '';

        buildInputs = [haxe neko];

        dontStrip=1;

        installPhase=":";

        meta = {
          inherit description;
          homepage = http://haxe.org;
          # license = "?"; TODO
          maintainers = [args.lib.maintainers.marcweber];
          platforms = args.lib.platforms.linux;
        };

      };

in

{

  inherit haxe;

  haxelib = tool {
    name = "haxelib";
    description = "haxelib is a HaXe library management tool similar to easyinstall or ruby gems";
  };

}
