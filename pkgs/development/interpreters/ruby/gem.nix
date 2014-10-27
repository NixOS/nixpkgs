{ ruby, fetchurl, rake, rubygemsFun, makeWrapper, lib, git }:

{ name
, namePrefix ? "ruby${ruby.majorVersion}" + "-"
, buildInputs ? []
, doCheck ? false # TODO: fix this
, dontBuild ? true
, meta ? {}
, gemPath ? []
, testTask ? "test"
, ...} @ attrs:

let
  rubygems = rubygemsFun ruby;

in ruby.stdenv.mkDerivation (attrs // {
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
    gempkg=`echo $output|grep -oP 'File: \K(.*)'`

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
    GEM_HOME=$out \
      gem install \
      --local \
      --force \
      --http-proxy "http://nodtd.invalid" \
      --ignore-dependencies \
      --build-root "/" \
      --bindir "$out/bin" \
      --backtrace \
      $gempkg $gemFlags -- $buildFlags

    rm -frv $out/cache # don't keep the .gem file here

    for prog in $out/bin/*; do
      wrapProgram "$prog" \
        --prefix GEM_PATH : "$out:$GEM_PATH" \
        --prefix RUBYLIB : "${rubygems}/lib" \
        --set RUBYOPT rubygems \
        $extraWrapperFlags ''${extraWrapperFlagsArray[@]}
    done

    # looks like useless files which break build repeatability and consume space
    rm -fv $out/doc/*/*/created.rid || true
    rm -fv $out/gems/*/ext/*/mkmf.log || true

    mkdir -p $out/nix-support

    cat > $out/nix-support/setup-hook <<EOF
    if [[ "$GEM_PATH" != *$out* ]]; then
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
