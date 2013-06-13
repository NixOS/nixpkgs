{ stdenv, fetchurl, gpgme, ruby, rubygems, hoe }:

stdenv.mkDerivation {
  name = "ruby-gpgme-1.0.8";

  src = fetchurl {
    url = "https://github.com/ueno/ruby-gpgme/archive/1.0.8.tar.gz";
    sha256 = "1j7jkl9s8iqcmxf3x6c9kljm19hw1jg6yvwbndmkw43qacdr9nxb";
  };

  meta = {
    description = ''
      Ruby-GPGME is a Ruby language binding of GPGME (GnuPG Made
      Easy)
    '';
    homepage = "http://rubyforge.org/projects/ruby-gpgme/";
    longDescription = ''
      Ruby-GPGME is a Ruby language binding of GPGME (GnuPG Made Easy).

      GnuPG Made Easy (GPGME) is a library designed to make access to GnuPG
      easier for applications. It provides a High-Level Crypto API for
      encryption, decryption, signing, signature verification and key
      management.
    '';
  };

  buildInputs = [ gpgme rubygems hoe ruby ];

  buildPhase = ''
    ${ruby}/bin/ruby extconf.rb
    rake gem
  '';

  installPhase = ''
    export HOME=$TMP/home; mkdir -pv "$HOME"

    # For some reason, the installation phase doesn't work with the default
    # make install command run by gem (we'll fix it and do it ourselves later)
    gem install --no-verbose --install-dir "$out/${ruby.gemPath}" \
        --bindir "$out/bin" --no-rdoc --no-ri pkg/gpgme-1.0.8.gem || true

    # Create a bare-bones gemspec file so that ruby will recognise the gem
    cat <<EOF >"$out/${ruby.gemPath}/specifications/gpgme.gemspec"
    Gem::Specification.new do |s|
      s.name              = 'gpgme'
      s.version           = '1.0.8'
      s.files             = Dir['{lib,examples}/**/*']
      s.rubyforge_project = 'ruby-gpgme'
      s.require_paths     = ['lib']
    end
    EOF

    cd "$out/${ruby.gemPath}/gems/gpgme-1.0.8"
    mkdir src
    mv lib src
    sed -i "s/srcdir = ./srcdir = src/" Makefile
    make install

    mv lib lib.bak
    mv src/lib lib
    rmdir src
  '';
}

