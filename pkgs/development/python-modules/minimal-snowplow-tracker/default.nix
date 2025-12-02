{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  six,
}:

buildPythonPackage rec {
  pname = "minimal-snowplow-tracker";
  version = "0.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rKv3Vy2w5/XL9pg9SV7vVAgfcb45IzDrOq25zLOdqqQ=";
  };

  propagatedBuildInputs = [
    requests
    six
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "snowplow_tracker" ];

  meta = with lib; {
    description = "Minimal snowplow event tracker";
    homepage = "https://github.com/dbt-labs/snowplow-python-tracker";
    license = licenses.asl20;
    maintainers = with maintainers; [
      mausch
    ];
  };
}
