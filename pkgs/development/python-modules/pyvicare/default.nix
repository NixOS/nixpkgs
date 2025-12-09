{
  lib,
  authlib,
  buildPythonPackage,
  deprecated,
  fetchFromGitHub,
  poetry-core,
  requests,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyvicare";
  version = "2.55.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openviess";
    repo = "PyViCare";
    tag = version;
    hash = "sha256-fKQ0NXUsL8NgmKr8BEoGV2fty39l19fg4B6Eg90X2kI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.1.0"' 'version = "${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    authlib
    deprecated
    requests
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "PyViCare" ];

  meta = with lib; {
    changelog = "https://github.com/openviess/PyViCare/releases/tag/${src.tag}";
    description = "Python Library to access Viessmann ViCare API";
    homepage = "https://github.com/somm15/PyViCare";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
