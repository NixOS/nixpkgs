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
    knownVulnerabilities = [
      "This package has not recieved updates upstream (from Travis CI) in 2+ years."
      "Its outdated dependencies are known to have the following security issues:"
      "CVE-2022-31163"
      "CVE-2021-32740"
      "CVE-2023-38037"
      "CVE-2023-28120"
      "CVE-2023-22796"
    ];
  };
}
