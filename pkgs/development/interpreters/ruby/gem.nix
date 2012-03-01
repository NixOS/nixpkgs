{stdenv, fetchurl, ruby, rubygems, makeWrapper, patches, overrides}:

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
          --set RUBYOPT rubygems \
          $extraWrapperFlags ''${extraWrapperFlagsArray[@]}
      done

      for prog in $out/gems/*/bin/*; do
        [[ -e "$out/bin/$(basename $prog)" ]]
      done

      runHook postInstall
    '';

    propagatedUserEnvPkgs = requiredGems;
    postFixup = ''
      if [ -n "$propagatedUserEnvPkgs" ]; then
          mkdir -p "$out/nix-support"
          echo "$propagatedUserEnvPkgs" > "$out/nix-support/propagated-user-env-packages"
      fi
    '';

  };
  mb = stdenv.lib.maybeAttr;
  patchedGem = a: stdenv.mkDerivation (removeAttrs (stdenv.lib.mergeAttrsByFuncDefaults
      ([ (gemDefaults a) ]
      ++ (stdenv.lib.concatMap (p: [(mb a.basename {} p) (mb a.name {} p)] )
      patches)))
    [ "mergeAttrBy" ]);
in
aName: a@{ name, basename, requiredGems, sha256, meta }:
  stdenv.lib.foldl (d: o: mb name (mb basename d o) o) (patchedGem a) overrides
