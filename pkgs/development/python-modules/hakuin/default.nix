{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  jinja2,
  nltk,
  pyprojectVersionPatchHook,
  sqlglot,
}:

buildPythonPackage (finalAttrs: {
  pname = "hakuin";
  version = "0.2.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pruzko";
    repo = "hakuin";
    tag = finalAttrs.version;
    hash = "sha256-97nh+woUsCXcoO2i5KprCwJiE24V3mg91qcNgy7bpgg=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    aiohttp
    jinja2
    nltk
    sqlglot
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "hakuin" ];

  meta = {
    description = "Blind SQL Injection optimization and automation framework";
    homepage = "https://github.com/pruzko/hakuin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "hk";
  };
})
