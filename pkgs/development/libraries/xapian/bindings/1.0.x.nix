{ stdenv, composableDerivation, fetchurl, xapian10, pkgconfig
, python ? null, php ? null, ruby ? null }:

let inherit (composableDerivation) wwf; in

composableDerivation.composableDerivation {} rec {

  name = "xapian-bindings-1.0.23";

  src = fetchurl {
    url = "http://oligarchy.co.uk/xapian/1.0.23/${name}.tar.gz";
    sha256 = "6028123c3cd9bfc380b672b89f5420f7d5c063fc3511dee4dd5d34033ccb6911";
  };

  buildInputs = [ xapian10 pkgconfig ];

  # most interpreters aren't tested yet.. (see python for example how to do it)
  flags =
         wwf {
           name = "python";
           enable = {
            buildInputs = [ python ];
            # export same env vars as in pythonNew
            preConfigure = ''
              export PYTHON_LIB=$out/lib/${python.libPrefix}/site-packages
              mkdir -p $out/nix-support
              echo "export NIX_PYTHON_SITES=\"$out:\$NIX_PYTHON_SITES\"" >> $out/nix-support/setup-hook 
              echo "export PYTHONPATH=\"$PYTHON_LIB:\$PYTHONPATH\"" >> $out/nix-support/setup-hook 
            '';
           };
         }
      // wwf {
           name = "php";
           enable = {
             buildInputs = [ php ];
             preConfigure = ''
               export PHP_EXTENSION_DIR=$out/lib/php # TODO use a sane directory. Its not used anywhere by now
             '';
           };
         }
      // wwf {
           name = "ruby";
           enable = {
             buildInputs = [ ruby ];
             # export same env vars as in rubyLibs 
             preConfigure = ''
               export RUBY_LIB=$out/${ruby.libPath}
               export RUBY_LIB_ARCH=$RUBY_LIB
               mkdir -p $out/nix-support
               echo "export RUBYLIB=\"$RUBY_LIB:\$RUBYLIB\"" >> $out/nix-support/setup-hook 
               echo "export GEM_PATH=\"$out:\$GEM_PATH\"" >> $out/nix-support/setup-hook 
             '';
           };
         }

      # note: see configure --help to get see which env vars can be used
      # // wwf { name = "tcl";     enable = { buildInputs = [ tcl ];};}
      # // wwf { name = "csharp"; }
      # // wwf { name = "java"; }
      ;

  cfg = {
    pythonSupport = true;
    phpSupport = true;
    rubySupport = true;
  };

  meta = { 
    description = "Bindings for the Xapian library";
    homepage = xapian10.meta.homepage;
    license = "GPLv2+";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
  };
}
