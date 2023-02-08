{ stdenv, lib, buildPythonPackage, fetchPypi, isPy3k, pythonOlder, cython
, attrs, click, cligj, click-plugins, six, munch, enum34
, pytestCheckHook, boto3, mock, giflib, pytz
, gdal, certifi
}:

buildPythonPackage rec {
  pname = "fiona";
  version = "1.9.0";

  src = fetchPypi {
    pname = "Fiona";
    inherit version;
    hash = "sha256-bkh8v7pahJ+98G5FFp/X4fFmL0Tz1xerS5RgRrJFfq4=";
  };

  CXXFLAGS = lib.optionalString stdenv.cc.isClang "-std=c++11";

  nativeBuildInputs = [
    cython
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

  nativeCheckInputs = [
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
    # https://github.com/Toblerity/Fiona/issues/1164
    "test_no_append_driver_cannot_append"
  ];

  pythonImportsCheck = [ "fiona" ];

  meta = with lib; {
    description = "OGR's neat, nimble, no-nonsense API for Python";
    homepage = "https://fiona.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
