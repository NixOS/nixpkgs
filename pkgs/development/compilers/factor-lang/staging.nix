{
  lib,
  stdenv,
  factor-unwrapped,
}:
stdenv.mkDerivation {
  pname = "factor-staging-images";
  inherit (factor-unwrapped) version meta;

  dontUnpack = true;

  preBuild = ''
    # Factor uses XDG_CACHE_HOME for cache during compilation.
    # We can't have that. So, set it to $TMPDIR/.cache
    export XDG_CACHE_HOME=$TMPDIR/.cache
    mkdir -p $XDG_CACHE_HOME
  '';

  buildPhase = ''
    runHook preBuild
    ${factor-unwrapped}/lib/factor/factor -script -e='USING: kernel system tools.deploy.backend ; "compiler" "hello-world" [ deploy-config config>profile make-staging-image ] bi@'
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/lib/factor
    cp -r $XDG_CACHE_HOME/factor/staging.* $out/lib/factor
  '';
}
