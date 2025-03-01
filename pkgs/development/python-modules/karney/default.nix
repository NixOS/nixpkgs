{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  numpy,
  poetry-core,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "karney";
  version = "1.0.10";
  pyproject = true;

  doCheck = true;

  src = fetchFromGitHub {
    inherit version;
    owner = "pbrod";
    repo = "karney";
    tag = "v${version}";
    hash = "sha256-UuHj7fBtWH6+kFsrOQya9odeQ1hR4UdlyXK48G4gH7o=";
  };

  build-system = [ poetry-core ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [ "karney" ];

  meta = with lib; {
    changelog = "https://github.com/pbrod/karney/blob/main/CHANGELOG.md";
    homepage = "https://github.com/pbrod/karney";
    description = "Provides native Python geodesic calculations";
    license = licenses.mit;
    maintainers = with maintainers; [ stillinbeta ];
  };
}
