{
  # Basic
  lib,
  buildPythonPackage,
  fetchPypi,
  # Build system
  setuptools,
  wheel,
  # Dependencies
  httpx,
  pydantic,
}:

buildPythonPackage rec {
  pname = "honcho-ai";
  version = "2.5.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "honcho_ai";
    inherit version;
    hash = "sha256-YWlzHHb4MpivzwgAV7pndOtnnlqrHeS3S7OiceGp3eM=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    httpx
    pydantic
  ];

  pythonImportsCheck = [ "honcho" ];

  meta = with lib; {
    description = "Python SDK for AI memory platform Honcho";
    homepage = "https://github.com/plastic-labs/honcho";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ thattemperature ];
  };
}
