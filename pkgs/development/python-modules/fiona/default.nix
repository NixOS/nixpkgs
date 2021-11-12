{ stdenv, lib, buildPythonPackage, fetchPypi, isPy3k, pythonOlder
, attrs, click, cligj, click-plugins, six, munch, enum34
, pytestCheckHook, boto3, mock, giflib, pytz
, gdal, certifi
}:

buildPythonPackage rec {
  pname = "fiona";
  version = "1.8.20";

  src = fetchPypi {
    pname = "Fiona";
    inherit version;
    sha256 = "a70502d2857b82f749c09cb0dea3726787747933a2a1599b5ab787d74e3c143b";
  };

  CXXFLAGS = lib.optionalString stdenv.cc.isClang "-std=c++11";

  nativeBuildInputs = [
    gdal # for gdal-config
  ];

  buildInputs = [
    gdal
  ] ++ lib.optionals stdenv.cc.isClang [ giflib ];

  propagatedBuildInputs = [
    attrs
    certifi
    click
    cligj
    click-plugins
    six
    munch
    pytz
  ] ++ lib.optional (!isPy3k) enum34;

  checkInputs = [
    pytestCheckHook
    boto3
  ] ++ lib.optional (pythonOlder "3.4") mock;

  preCheck = ''
    rm -r fiona # prevent importing local fiona
    # disable gdal deprecation warnings
    export GDAL_ENABLE_DEPRECATED_DRIVER_GTM=YES
  '';

  disabledTests = [
    # Some tests access network, others test packaging
    "http" "https" "wheel"
    # Assert not true
    "test_no_append_driver_cannot_append"
  ];

  meta = with lib; {
    description = "OGR's neat, nimble, no-nonsense API for Python";
    homepage = "https://fiona.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
