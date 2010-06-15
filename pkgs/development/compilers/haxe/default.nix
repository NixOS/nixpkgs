args: with args;

let

    src_haxe_swflib = {
      # REGION AUTO UPDATE:                                { name = "haxe_swflib"; type="cvs"; cvsRoot = ":pserver:anonymous@cvs.motion-twin.com:/cvsroot"; module = "ocaml/swflib"; groups = "haxe_group"; }
      src = sourceFromHead "haxe_swflib-F_10-43-46.tar.gz"
                   (fetchurl { url = "http://mawercer.de/~nix/repos/haxe_swflib-F_10-43-46.tar.gz"; sha256 = "a63de75e48bf500ef0e8ef715d178d32f0ef113ded8c21bbca698a8cc70e7b58"; });
      # END
    }.src;

    src_haxe_extc = { 
      # REGION AUTO UPDATE:                                { name = "haxe_extc"; type="cvs"; cvsRoot = ":pserver:anonymous@cvs.motion-twin.com:/cvsroot"; module = "ocaml/extc"; groups = "haxe_group"; }
      src = sourceFromHead "haxe_extc-F_10-43-47.tar.gz"
                   (fetchurl { url = "http://mawercer.de/~nix/repos/haxe_extc-F_10-43-47.tar.gz"; sha256 = "d0a9980527d62ac6cfe27925ddb0964d334ec382f813fdfb8bd6c59fbbede730"; });
      # END
    }.src;

    src_haxe_extlib_dev = { 
      # REGION AUTO UPDATE:                                { name = "haxe_extlib_dev"; type="cvs"; cvsRoot = ":pserver:anonymous@cvs.motion-twin.com:/cvsroot"; module = "ocaml/extlib-dev"; groups = "haxe_group"; }
      src = sourceFromHead "haxe_extlib_dev-F_10-43-48.tar.gz"
                   (fetchurl { url = "http://mawercer.de/~nix/repos/haxe_extlib_dev-F_10-43-48.tar.gz"; sha256 = "6b9037230e2615dd5e22f4e7f4165c84f2816bc526957683afc945394fcdf67e"; });
      # END
    }.src;

    src_haxe_xml_light = { 
      # REGION AUTO UPDATE:                                { name = "haxe_xml_light"; type="cvs"; cvsRoot = ":pserver:anonymous@cvs.motion-twin.com:/cvsroot"; module = "ocaml/xml-light"; groups = "haxe_group"; }
      src = sourceFromHead "haxe_xml_light-F_10-43-48.tar.gz"
                   (fetchurl { url = "http://mawercer.de/~nix/repos/haxe_xml_light-F_10-43-48.tar.gz"; sha256 = "be29d9e22ad0dbcb3d447cbbc14907aff5f89bb562b8db369659d299f3a5b44f"; });
      # END
    }.src;

    src_haxe_neko_include = { 
      # REGION AUTO UPDATE:                                { name = "haxe_neko_include"; type="cvs"; cvsRoot = ":pserver:anonymous@cvs.motion-twin.com:/cvsroot"; module = "neko/libs/include/ocaml"; groups = "haxe_group"; }
      src = sourceFromHead "haxe_neko_include-F_10-43-49.tar.gz"
                   (fetchurl { url = "http://mawercer.de/~nix/repos/haxe_neko_include-F_10-43-49.tar.gz"; sha256 = "e49efc1b348fa6e0f6fb40079a2d380b947d9ebda31843bc293f3cc77f8453db"; });
      # END
    }.src;

    src_haxe = {
      # REGION AUTO UPDATE:       { name="haxe-read-only"; type="svn"; url="http://haxe.googlecode.com/svn/trunk"; groups = "haxe_group"; }
      src = sourceFromHead "haxe-read-only-3220.tar.gz"
                   (fetchurl { url = "http://mawercer.de/~nix/repos/haxe-read-only-3220.tar.gz"; sha256 = "2b6702dca95d0829e539cea07b8224e3848e584a425ce8f8e0984a7a2bf7b1f8"; });
      # END
    }.src;


    # the HaXe compiler
    haxe = stdenv.mkDerivation {
      name = "haxe-cvs";

      buildInputs = [ocaml zlib makeWrapper];

      src = src_haxe;

      inherit zlib;

      NUM_CORES = 1;

      buildPhase = ''
        set -x
        mkdir -p ocaml/{swflib,extc,extlib-dev,xml-light} neko/libs

        # strange setup. install.ml seems to co the same repo again into haxe directory!
        mkdir haxe
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
