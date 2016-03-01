{ stdenv, lib, fetchurl, makeWrapper, ruby }:

stdenv.mkDerivation rec {
  name = "rubygems-${version}";
  version = "2.5.2";
  src = fetchurl {
    url = "http://production.cf.rubygems.org/rubygems/${name}.tgz";
    sha256 = "1jpcmvjfpj2m0jh23371ghfj95gh4jliihzrj5ln0x2cl1pwwwai";
  };

  patches = [ ./gem_hook.patch ];

  buildInputs = [ruby makeWrapper];

  buildPhase = ":";

  installPhase = ''
    ruby setup.rb --prefix=$out/

    wrapProgram $out/bin/gem --prefix RUBYLIB : $out/lib

    find $out -type f -name "*.rb" |
      xargs sed -i "s@/usr/bin/env@$(type -p env)@g"

    mkdir -pv $out/nix-support
    cat > $out/nix-support/setup-hook <<EOF
    export RUBYOPT=rubygems
    addToSearchPath RUBYLIB $out/lib
    EOF
  '';

  meta = {
    description = "A package management framework for Ruby";
  };
}
