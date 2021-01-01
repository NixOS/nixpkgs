{ stdenv, lib, buildPythonPackage, fetchPypi, isPy3k, pythonOlder
, attrs, click, cligj, click-plugins, six, munch, enum34
, pytest, boto3, mock, giflib, pytz
, gdal_2 # can't bump to 3 yet, https://github.com/Toblerity/Fiona/issues/745
}:

buildPythonPackage rec {
  pname = "Fiona";
  version = "1.8.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b732ece0ff8886a29c439723a3e1fc382718804bb057519d537a81308854967a";
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
    pytz
  ] ++ lib.optional (!isPy3k) enum34;

  checkInputs = [
    pytest
    boto3
  ] ++ lib.optional (pythonOlder "3.4") mock;

  checkPhase = ''
    rm -r fiona # prevent importing local fiona
    # Some tests access network, others test packaging
    pytest -k "not (http or https or wheel)"
  '';

  meta = with lib; {
    description = "OGR's neat, nimble, no-nonsense API for Python";
    homepage = "https://fiona.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
