{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  python-dateutil,
  types-python-dateutil,
  tzdata,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
  pytz,
  simplejson,
}:

buildPythonPackage (finalAttrs: {
  pname = "arrow";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "crsmithdev";
    repo = "arrow";
    tag = finalAttrs.version;
    hash = "sha256-nK78Lo+7eitB+RS7BZkM+BNudviirAowc4a1uQdLC0w=";
  };

  build-system = [ flit-core ];

  dependencies = [
    python-dateutil
    types-python-dateutil
    tzdata
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
    pytz
    simplejson
  ];

  # ParserError: Could not parse timezone expression "America/Nuuk"
  #disabledTests = [ "test_parse_tz_name_zzz" ];

  pythonImportsCheck = [ "arrow" ];

  meta = {
    changelog = "https://github.com/arrow-py/arrow/releases/tag/${finalAttrs.src.tag}";
    description = "Python library for date manipulation";
    homepage = "https://github.com/crsmithdev/arrow";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
})
