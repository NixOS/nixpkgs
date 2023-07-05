{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cython
, gdal
, setuptools
, attrs
, certifi
, click
, click-plugins
, cligj
, munch
, shapely
, boto3
, pytestCheckHook
, pytz
}:

buildPythonPackage rec {
  pname = "fiona";
  version = "1.9.1";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Toblerity";
    repo = "Fiona";
    rev = "refs/tags/${version}";
    hash = "sha256-2CGLkgnpCAh9G+ILol5tmRj9S6/XeKk8eLzGEODiyP8=";
  };

  nativeBuildInputs = [
    cython
    gdal # for gdal-config
    setuptools
  ];

  buildInputs = [
    gdal
  ];

  propagatedBuildInputs = [
    attrs
    certifi
    click
    cligj
    click-plugins
    munch
    setuptools
  ];

  passthru.optional-dependencies = {
    calc = [ shapely ];
    s3 = [ boto3 ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytz
  ] ++ passthru.optional-dependencies.s3;

  preCheck = ''
    rm -r fiona # prevent importing local fiona
  '';

  disabledTests = [
    # Some tests access network, others test packaging
    "http" "https" "wheel"
  ];

  pythonImportsCheck = [ "fiona" ];

  meta = with lib; {
    changelog = "https://github.com/Toblerity/Fiona/blob/${src.rev}/CHANGES.txt";
    description = "OGR's neat, nimble, no-nonsense API for Python";
    homepage = "https://fiona.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = teams.geospatial.members;
  };
}
