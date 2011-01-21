{stdenv, fetchurl, ruby, rubygems, makeWrapper, patches, overwrites}:

let
  gemDefaults = { name, basename, requiredGems, sha256, meta }:
  {
    buildInputs = [rubygems ruby makeWrapper];
    unpackPhase = ":";
    configurePhase=":";
    bulidPhase=":";

    src = fetchurl {
      url = "http://rubygems.org/downloads/${name}.gem";
      inherit sha256;
    };

    name = "ruby-${name}";

    propagatedBuildInputs = requiredGems;
    inherit meta;

    installPhase = ''
      export HOME=$TMP/home; mkdir -pv "$HOME"

      gem install -V --ignore-dependencies \
      -i "$out/${ruby.gemPath}" -n "$out/bin" "$src" $gemFlags -- $buildFlags
      rm -frv $out/${ruby.gemPath}/cache # don't keep the .gem file here

      addToSearchPath GEM_PATH $out/${ruby.gemPath}

      for prog in $out/bin/*; do
        wrapProgram "$prog" \
          --prefix GEM_PATH : "$GEM_PATH" \
          --prefix RUBYLIB : "${rubygems}/lib" \
          --set RUBYOPT 'rubygems'
      done

      for prog in $out/gems/*/bin/*; do
        [[ -e "$out/bin/$(basename $prog)" ]]
      done

      runHook postInstall
    '';
  };
  mb = stdenv.lib.maybeAttr;
in
aName: a@{ name, basename, requiredGems, sha256, meta }:
  mb name (mb basename (
    stdenv.mkDerivation (removeAttrs (stdenv.lib.mergeAttrsByFuncDefaults
      [ (gemDefaults a) (mb name {} patches) (mb basename {} patches) ]
    ) ["mergeAttrBy"])
  ) overwrites) overwrites
