{ stdenv, lib, fetchurl, makeWrapper, ruby }:

stdenv.mkDerivation rec {
  name = "rubygems-${version}";
  version = "2.4.1";
  src = fetchurl {
    url = "http://production.cf.rubygems.org/rubygems/${name}.tgz";
    sha256 = "0cpr6cx3h74ykpb0cp4p4xg7a8j0bhz3sk271jq69l4mm4zy4h4f";
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
