{ stdenv, lib, buildPythonPackage, fetchPypi, isPy3k, pythonOlder
, attrs, click, cligj, click-plugins, six, munch, enum34
, pytest, boto3, mock, giflib
, gdal_2 # can't bump to 3 yet, https://github.com/Toblerity/Fiona/issues/745
}:

buildPythonPackage rec {
  pname = "Fiona";
  version = "1.8.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ec34898c8b983a723fb4e949dd3e0ed7e691c303e51f6bfd61e52ac9ac813ae";
  };

  CXXFLAGS = lib.optionalString stdenv.cc.isClang "-std=c++11";

  nativeBuildInputs = [
    gdal_2 # for gdal-config
  ];

  buildInputs = [
    gdal_2
  ] ++ lib.optionals stdenv.cc.isClang [ giflib ];

  propagatedBuildInputs = [
    attrs
    click
    cligj
    click-plugins
    six
    munch
  ] ++ lib.optional (!isPy3k) enum34;

  checkInputs = [
    pytest
    boto3
  ] ++ lib.optional (pythonOlder "3.4") mock;

  checkPhase = ''
    rm -r fiona # prevent importing local fiona
    # Some tests access network, others test packaging
    pytest -k "not test_*_http \
           and not test_*_https \
           and not test_*_wheel"
  '';

  meta = with lib; {
    description = "OGR's neat, nimble, no-nonsense API for Python";
    homepage = "https://fiona.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
