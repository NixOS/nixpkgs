{
  lib,
  aiohttp,
  buildPythonPackage,
  emoji,
  fetchFromGitHub,
  freezegun,
  tzdata,
  pdoc,
  pydantic,
  pytest-aiohttp,
  pytest-benchmark,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "ical";
  version = "14.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "ical";
    tag = finalAttrs.version;
    hash = "sha256-YbYZbgSEqfQP4VQ/g25o+NbCBLU0dxA0laoeP7c54Fw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    tzdata
    pydantic
  ];

  optional-dependencies = {
    async = [ aiohttp ];
  };

  nativeCheckInputs = [
    emoji
    freezegun
    pdoc
    pytest-aiohttp
    pytest-benchmark
    pytestCheckHook
    syrupy
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pytestFlags = [ "--benchmark-disable" ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "ical" ];

  meta = {
    description = "Library for handling iCalendar";
    homepage = "https://github.com/allenporter/ical";
    changelog = "https://github.com/allenporter/ical/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
