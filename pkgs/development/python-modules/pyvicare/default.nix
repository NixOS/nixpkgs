{
  lib,
  authlib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  requests,
  pytest-cov-stub,
  pytestCheckHook,
  simplejson,
}:

buildPythonPackage rec {
  pname = "pyvicare";
  version = "2.39.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openviess";
    repo = "PyViCare";
    tag = version;
    hash = "sha256-gD6eLhng8oUmXPHOwYZoyLRpMQBgH0xbopaVJ6qJQsg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.1.0"' 'version = "${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    authlib
    requests
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "PyViCare" ];

  meta = with lib; {
    changelog = "https://github.com/openviess/PyViCare/releases/tag/${version}";
    description = "Python Library to access Viessmann ViCare API";
    homepage = "https://github.com/somm15/PyViCare";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
