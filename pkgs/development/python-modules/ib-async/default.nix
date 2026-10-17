{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aeventkit,
  nest-asyncio,
  pandas,
  poetry-core,
  pytestCheckHook,
  tzdata,
}:
buildPythonPackage (finalAttrs: {
  pname = "ib_async";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ib-api-reloaded";
    repo = "ib_async";
    rev = "ab629f34c1823ea4c1542f32f07377208a86bdfd";
    sha256 = "sha256-B4XC122EWjs9+nc8dgk9VanQyN0L8jR/cV2Bp74yPE4=";
  };

  build-system = [ poetry-core ];
  dependencies = [
    aeventkit
    nest-asyncio
    tzdata
  ];
  pythonRelaxDeps = [ "tzdata" ];
  nativeCheckInputs = [
    pytestCheckHook
    pandas
  ];
  meta = {
    description = "Python sync/async framework for Interactive Brokers API";
    homepage = "https://github.com/ib-api-reloaded/ib_async";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.supermarin ];
  };
})
