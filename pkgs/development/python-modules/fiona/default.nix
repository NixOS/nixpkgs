{ stdenv, buildPythonPackage, fetchPypi, isPy3k, pythonOlder
, attrs, click, cligj, click-plugins, six, munch, enum34
, pytest, boto3, mock
, gdal_2 # can't bump to 3 yet, https://github.com/Toblerity/Fiona/issues/745
}:

buildPythonPackage rec {
  pname = "Fiona";
  version = "1.8.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gpvdrayam4qvpqvz0911nlyvf7ib3slsyml52qx172vhpldycgs";
  };

  CXXFLAGS = stdenv.lib.optionalString stdenv.cc.isClang "-std=c++11";

  nativeBuildInputs = [
    gdal_2 # for gdal-config
  ];

  buildInputs = [
    gdal_2
  ];

  propagatedBuildInputs = [
    attrs
    click
    cligj
    click-plugins
    six
    munch
  ] ++ stdenv.lib.optional (!isPy3k) enum34;

  checkInputs = [
    pytest
    boto3
  ] ++ stdenv.lib.optional (pythonOlder "3.4") mock;

  checkPhase = ''
    rm -r fiona # prevent importing local fiona
    # Some tests access network, others test packaging
    pytest -k "not test_*_http \
           and not test_*_https \
           and not test_*_wheel"
  '';

  meta = with stdenv.lib; {
    description = "OGR's neat, nimble, no-nonsense API for Python";
    homepage = http://toblerity.org/fiona/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
