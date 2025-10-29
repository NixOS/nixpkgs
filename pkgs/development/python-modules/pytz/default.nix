{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  tzdata,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytz";
  version = "2025.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NguePbtJognCGtYYCcf7RTZD4EiziSTHZYE1RnRugcM=";
  };

  postPatch = ''
    # Use our system-wide zoneinfo dir instead of the bundled one
    rm -rf pytz/zoneinfo
    ln -snvf ${tzdata}/share/zoneinfo pytz/zoneinfo
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "pytz/tests"
  ];

  pythonImportsCheck = [ "pytz" ];

  meta = with lib; {
    changelog = "https://launchpad.net/pytz/+announcements";
    description = "World timezone definitions, modern and historical";
    homepage = "https://pythonhosted.org/pytz";
    license = licenses.mit;
    maintainers = with maintainers; [
      dotlambda
      jherland
    ];
  };
}
