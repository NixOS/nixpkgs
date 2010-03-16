args: with args;

let

    src_haxe_swflib = {
      # REGION AUTO UPDATE:                          { name = "haxe_swflib"; type="cvs"; cvsRoot = ":pserver:anonymous@cvs.motion-twin.com:/cvsroot"; module = "ocaml/swflib"; groups = "haxe_group"; }
      src= sourceFromHead "haxe_swflib-F_01-25-00.tar.gz"
                   (fetchurl { url = "http://mawercer.de/~nix/repos/haxe_swflib-F_01-25-00.tar.gz"; sha256 = "ddea39427de23ff58d3b942bbcce2aac7a25dc11ae06ef983653c82614eba9cd"; });
      # END
    }.src;

    src_haxe_extc = { 
      # REGION AUTO UPDATE:                          { name = "haxe_extc"; type="cvs"; cvsRoot = ":pserver:anonymous@cvs.motion-twin.com:/cvsroot"; module = "ocaml/extc"; groups = "haxe_group"; }
      src= sourceFromHead "haxe_extc-F_01-25-08.tar.gz"
                   (fetchurl { url = "http://mawercer.de/~nix/repos/haxe_extc-F_01-25-08.tar.gz"; sha256 = "ab2100391735d39c93c72b236ec6e9c5cf09461311a7e3a714d867861926ae37"; });
      # END
    }.src;

    src_haxe_extlib_dev = { 
      # REGION AUTO UPDATE:                          { name = "haxe_extlib_dev"; type="cvs"; cvsRoot = ":pserver:anonymous@cvs.motion-twin.com:/cvsroot"; module = "ocaml/extlib-dev"; groups = "haxe_group"; }
      src= sourceFromHead "haxe_extlib_dev-F_01-25-17.tar.gz"
                   (fetchurl { url = "http://mawercer.de/~nix/repos/haxe_extlib_dev-F_01-25-17.tar.gz"; sha256 = "01c3c8afdf47a98320e65c0652492508854ea28ead0437abd17a4228b33c8066"; });
      # END
    }.src;

    src_haxe_xml_light = { 
      # REGION AUTO UPDATE:                          { name = "haxe_xml_light"; type="cvs"; cvsRoot = ":pserver:anonymous@cvs.motion-twin.com:/cvsroot"; module = "ocaml/xml-light"; groups = "haxe_group"; }
      src= sourceFromHead "haxe_xml_light-F_01-25-24.tar.gz"
                   (fetchurl { url = "http://mawercer.de/~nix/repos/haxe_xml_light-F_01-25-24.tar.gz"; sha256 = "7fe244681698995af54085bb2ab873d3dd1ff2fac33aa8e7b00fcbbc50249334"; });
      # END
    }.src;

    src_haxe_neko_include = { 
      # REGION AUTO UPDATE:                          { name = "haxe_neko_include"; type="cvs"; cvsRoot = ":pserver:anonymous@cvs.motion-twin.com:/cvsroot"; module = "neko/libs/include/ocaml"; groups = "haxe_group"; }
      src= sourceFromHead "haxe_neko_include-F_01-25-28.tar.gz"
                   (fetchurl { url = "http://mawercer.de/~nix/repos/haxe_neko_include-F_01-25-28.tar.gz"; sha256 = "8b642598889cf2fd1f99dfa037eef09b2511d30a8f5a6a75ee02b2e98fa4c6b7"; });
      # END
    }.src;

    src_haxe = {
      # REGION AUTO UPDATE:                             { name="haxe"; type="cvs"; cvsRoot = ":pserver:anonymous@cvs.motion-twin.com:/cvsroot"; module = "haxe"; groups = "haxe_group"; }
      src= sourceFromHead "haxe-F_01-25-35.tar.gz"
                   (fetchurl { url = "http://mawercer.de/~nix/repos/haxe-F_01-25-35.tar.gz"; sha256 = "8e5e5330e2fd7ffbbfe48d40bda03256aefbe30cf1be1d9c9065117b2b179f24"; });
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
