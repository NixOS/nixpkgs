{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pythonOlder,

  # build-system
  poetry-core,

  # dependencies
  fastjsonschema,
  requests,
  requests-toolbelt,
  xmltodict,
}:

buildPythonPackage (finalAttrs: {
  pname = "ciscoisesdk";
  version = "2.4.5";
  pyproject = true;

  __structuredAttrs = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "CiscoISE";
    repo = "ciscoisesdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DidTHJnrG4ptVeURz+M9s68oEqNI8CNghsF+ReUk3so=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    fastjsonschema
    requests
    requests-toolbelt
    xmltodict
  ];

  pythonImportsCheck = [ "ciscoisesdk" ];

  # The test suite talks to a live Cisco ISE deployment.
  doCheck = false;

  meta = {
    changelog = "https://github.com/CiscoISE/ciscoisesdk/releases/tag/${finalAttrs.src.tag}";
    description = "Cisco Identity Services Engine (ISE) Platform SDK";
    homepage = "https://github.com/CiscoISE/ciscoisesdk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
