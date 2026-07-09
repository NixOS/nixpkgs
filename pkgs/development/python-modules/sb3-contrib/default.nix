{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  stable-baselines3,
}:

buildPythonPackage (finalAttrs: {
  pname = "stable-baselines3-contrib";
  version = "2.9.0";
  src = fetchFromGitHub {
    owner = "Stable-Baselines-Team";
    repo = "stable-baselines3-contrib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HAaZKnplXSFfh42zQG1QUsKrMu7JFsWhhpP4r814RA0=";
  };
  pyproject = true;
  dependencies = [ stable-baselines3 ];
  meta = {
    description = "Contrib package for Stable-Baselines3 - Experimental reinforcement learning (RL) code";
    homepage = "https://sb3-contrib.readthedocs.io";
    changelog = "https://stable-baselines3.readthedocs.io/en/master/misc/changelog.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ n0099 ];
  };
})
