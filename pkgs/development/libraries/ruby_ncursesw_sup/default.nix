{ stdenv, fetchurl, ncurses, ruby, rubygems }:

stdenv.mkDerivation rec {
  name = ''ncursesw-sup-afd962b9c06108ff0643e98593c5605314d76917'';

  src = fetchurl {
    url = "https://github.com/sup-heliotrope/ncursesw-ruby/archive/afd962b9c06108ff0643e98593c5605314d76917.tar.gz";
    sha256 = "13i286p4bm8zqg9xh96a1dg7wkywj9m6975gbh3w43d3rmfc1h6a";
  };

  meta = {
    description = ''
      Hacked up version of ncurses gem that supports wide characters for
      supmua.org
    '';
    homepage = ''http://github.com/sup-heliotrope/ncursesw-ruby'';
    longDescription = ''
      This wrapper provides access to the functions, macros, global variables
      and constants of the ncurses library.  These are mapped to a Ruby Module
      named "Ncurses":  Functions and external variables are implemented as
      singleton functions of the Module Ncurses.
    '';
  };

  buildInputs = [ ncurses rubygems ];

  buildPhase = "gem build ncursesw.gemspec";

  installPhase = ''
    export HOME=$TMP/home; mkdir -pv "$HOME"

    # For some reason, the installation phase doesn't work with the default
    # make install command run by gem (we'll fix it and do it ourselves later)
    gem install --no-verbose --install-dir "$out/${ruby.gemPath}" \
        --bindir "$out/bin" --no-rdoc --no-ri ncursesw-sup-1.3.1.2.gem || true

    # Needed for ruby to recognise the gem
    cp ncursesw.gemspec "$out/${ruby.gemPath}/specifications"

    cd "$out/${ruby.gemPath}/gems/ncursesw-sup-1.3.1.2"
    mkdir src
    mv lib src
    sed -i "s/srcdir = ./srcdir = src/" Makefile
    make install
  '';
}

