{ stdenv
, buildPythonPackage
, fetchPypi
, cython
, isPy3k
, simplejson
}:

buildPythonPackage rec {
  pname = "meliae";
  version = "0.4.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16gcgjzcjlbfarwlj18fn089bz34kzfw8varbzxsi9ma0amijrcp";
  };

  disabled = isPy3k;

  doCheck = true;

  checkPhase = ''
    python setup.py build_ext -i
    python run_tests.py
  '';

  checkInputs = [ simplejson ];

  propagatedBuildInputs = [ cython ];

  meta = with stdenv.lib; {
    description = "Python Memory Usage Analyzer";
    homepage = http://launchpad.net/meliae;
    license = licenses.gpl3;
    maintainers = with maintainers; [ xvapx ];
  };
}
