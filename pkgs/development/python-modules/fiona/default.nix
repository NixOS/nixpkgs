{ stdenv, lib, buildPythonPackage, fetchPypi, isPy3k, pythonOlder
, attrs, click, cligj, click-plugins, six, munch, enum34
, pytestCheckHook, boto3, mock, giflib, pytz
, gdal, certifi
, fetchpatch
}:

buildPythonPackage rec {
  pname = "fiona";
  version = "1.8.22";

  src = fetchPypi {
    pname = "Fiona";
    inherit version;
    sha256 = "sha256-qCqZzps+eCV0AVfEXJ+yJZ1OkvCohqqsJfDbQP/h7qM=";
  };

  patches = [
    # https://github.com/Toblerity/Fiona/pull/1122
    (fetchpatch {
      url = "https://github.com/Toblerity/Fiona/commit/fa632130dcd9dfbb982ecaa4911b3fab3459168f.patch";
      hash = "sha256-IuNHr3yBqS1jY9Swvcq8XPv6BpVlInDx0FVuzEMaYTY=";
    })
  ];

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

  meta = with lib; {
    description = "OGR's neat, nimble, no-nonsense API for Python";
    homepage = "https://fiona.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
