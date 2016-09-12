{ stdenv, composableDerivation, fetchurl, xapian, pkgconfig, zlib
, python ? null, sphinx ? null, php ? null, ruby ? null }:

assert (python != null) -> (sphinx != null);

let inherit (composableDerivation) wwf; in

composableDerivation.composableDerivation {} rec {

  name = "xapian-bindings-${version}";
  version = (builtins.parseDrvName xapian.name).version;

  src = fetchurl {
    url = "http://oligarchy.co.uk/xapian/${version}/${name}.tar.xz";
    sha256 = "0lv2zblayfax4v7z3sj067b0av0phf3gc2s2d1cvkw0bkl07mv1s";
  };

  buildInputs = [ xapian pkgconfig zlib ];

  # most interpreters aren't tested yet.. (see python for example how to do it)
  flags =
         wwf {
           name = "python";
           enable = {
            buildInputs = [ python sphinx ];

            # Our `sphinx-build` binary is a shell wrapper around
            # `sphinx-build` python code. Makefile tries to execute it
            # using python2 and fails. Fixing that here.
            patchPhase = ''
              for a in python/Makefile* ; do
                substituteInPlace $a \
                  --replace '$(PYTHON2) $(SPHINX_BUILD)' '$(SPHINX_BUILD)'
              done
            '';

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
    phpSupport = false;
    rubySupport = true;
  };

  meta = {
    description = "Bindings for the Xapian library";
    homepage = xapian.meta.homepage;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.unix;
  };
}
