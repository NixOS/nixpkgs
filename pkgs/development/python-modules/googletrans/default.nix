{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  httpx,
}:

buildPythonPackage rec {
  pname = "googletrans";
  version = "4.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2e8Sa12S+r7sC7ndzb7s1Dhl/ADhfx36B3F4N4J6F94=";
  };

  build-system = [ hatchling ];

  dependencies = [ httpx ] ++ httpx.optional-dependencies.http2;

  # Majority of tests just try to ping Google's Translate API endpoint
  doCheck = false;

  pythonImportsCheck = [ "googletrans" ];

  meta = with lib; {
    description = "Library to interact with Google Translate API";
    homepage = "https://py-googletrans.readthedocs.io";
    changelog = "https://github.com/ssut/py-googletrans/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ unode ];
    mainProgram = "translate";
  };
}
