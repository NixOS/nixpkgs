{
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  lib,
  keyring,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "calendaring-config";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pycalendar";
    repo = "calendaring-config";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZGMqkgJ5K5OYdGf7AsNP3tPjFS4JbruNlFlPvjvNrRI=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    pyyaml
  ];

  optional-dependencies = {
    keyring = [ keyring ];
  };

  pythonImportsCheck = [ "calendaring_config" ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  meta = {
    changelog = "https://github.com/PyCalendar/calendaring-config/blob/${finalAttrs.src.tag}/docs/changelog.rst";
    description = "Shared configuration file of caldav, calendaring and calendaring-jmap: format, discovery and credentials";
    homepage = "https://github.com/pycalendar/calendaring-config";
    license =
      with lib.licenses;
      OR [
        asl20
        gpl3Plus
      ];
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
