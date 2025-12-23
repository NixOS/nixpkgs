{
  lib,
  bundlerEnv,
  ruby,
  bundlerUpdateScript,
}:

bundlerEnv {
  inherit ruby;
  pname = "travis";
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "travis";

  meta = {
    description = "CLI and Ruby client library for Travis CI";
    mainProgram = "travis";
    homepage = "https://github.com/travis-ci/travis.rb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      zimbatm
      nicknovitski
    ];
  };
}
