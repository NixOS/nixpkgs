{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  geojson,
  haversine,
  pytz,
  requests,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "geojson-client";
  version = "0.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-geojson-client";
    tag = "v${version}";
    hash = "sha256-nzM5P1ww6yWM3e2v3hRw0ECoYmRPhTs0Q7Wwicl+IpU=";
  };

  propagatedBuildInputs = [
    geojson
    haversine
    pytz
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "geojson_client" ];

  meta = {
    description = "Python module for convenient access to GeoJSON feeds";
    homepage = "https://github.com/exxamalte/python-geojson-client";
    changelog = "https://github.com/exxamalte/python-geojson-client/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
