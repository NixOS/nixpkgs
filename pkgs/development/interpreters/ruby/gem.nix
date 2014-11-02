{ lib, ruby, rubygemsFun, fetchurl, makeWrapper, git } @ defs:

lib.makeOverridable (

{ name
, ruby ? defs.ruby
, rubygems ? (rubygemsFun ruby)
, namePrefix ? "${ruby.name}" + "-"
, buildInputs ? []
, doCheck ? false
, dontBuild ? true
, meta ? {}
, gemPath ? []
, ...} @ attrs:

ruby.stdenv.mkDerivation (attrs // {
  inherit doCheck;

  buildInputs = [ rubygems makeWrapper git ] ++ buildInputs;

  name = namePrefix + name;

  src = if attrs ? src
    then attrs.src
    else fetchurl {
      url = "http://rubygems.org/downloads/${attrs.name}.gem";
      inherit (attrs) sha256;
    };

  # The source is expected to either be a gem package or a directory.
  #
  # - Gem packages are already built, so they don't even need to be unpacked.
  #   They will skip the buildPhase.
  # - A directory containing the sources will need to go through all of the
  #   usual phases.
  unpackPhase= ''
    gemRegex="\.gem"
    if [[ $src =~ $gemRegex ]]
    then
      runHook preUnpack
      echo "Source is a gem package, won't unpack."
      gempkg=$src
      dontBuild=1
      runHook postUnpack
    else
      # Fall back to the original thing for everything else.
      unpackPhase
    fi
  '';

  checkPhase = "true";

  buildPhase = ''
    runHook preBuild

    # TODO: Investigate. The complete working tree is touched by fetchgit.
    if [ -d .git ]; then
      git reset
    fi

    gemspec=`find . -name '*.gemspec'`
    output=`gem build $gemspec`

    gem build $gemspec | tee .output
    gempkg=`cat .output | grep -oP 'File: \K(.*)'`
    rm .output

    echo "Gem package built: $gempkg"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # NOTE: This does NOT build the unpacked gem, but installs $src directly.
    #       Gems that have not been downloaded from rubygems.org may need a
    #       separate buildPhase.
    #       --ignore-dependencies is necessary as rubygems otherwise always
    #       connects to the repository, thus breaking pure builds.
    GEM_HOME=$out/${ruby.gemPath} \
      gem install \
      --local \
      --force \
      --http-proxy "http://nodtd.invalid" \
      --ignore-dependencies \
      --build-root "/" \
      --backtrace \
      $gempkg $gemFlags -- $buildFlags

    rm -frv $out/${ruby.gemPath}/cache # don't keep the .gem file here

    mkdir -p $out/bin
    for prog in $out/${ruby.gemPath}/gems/*/bin/*; do
      makeWrapper $prog $out/bin/$(basename $prog) \
        --prefix GEM_PATH : "$out/${ruby.gemPath}:$GEM_PATH" \
        --prefix RUBYLIB : "${rubygems}/lib" \
        --set RUBYOPT rubygems \
        $extraWrapperFlags ''${extraWrapperFlagsArray[@]}
    done

    # looks like useless files which break build repeatability and consume space
    rm -fv $out/${ruby.gemPath}/doc/*/*/created.rid || true
    rm -fv $out/${ruby.gemPath}/gems/*/ext/*/mkmf.log || true

    mkdir -p $out/nix-support

    cat > $out/nix-support/setup-hook <<EOF
    if [[ "\$GEM_PATH" != *$out* ]]; then
      addToSearchPath GEM_PATH $out/${ruby.gemPath}
    fi
    EOF

    runHook postInstall
  '';

  propagatedBuildInputs = gemPath;
  propagatedUserEnvPkgs = gemPath;

  passthru.isRubyGem = true;
  inherit meta;
})

)
