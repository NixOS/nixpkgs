{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, nose
, toolz
, python
, isPy27
}:

buildPythonPackage rec {
  pname = "cytoolz";
  version = "0.11.2";
  disabled = isPy27 || isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ea23663153806edddce7e4153d1d407d62357c05120a4e8485bddf1bd5ab22b4";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ toolz ];

  checkPhase = ''
    nosetests -v $out/${python.sitePackages}
  '';

  meta = {
    homepage = "https://github.com/pytoolz/cytoolz/";
    description = "Cython implementation of Toolz: High performance functional utilities";
    license = "licenses.bsd3";
    maintainers = with lib.maintainers; [ fridh ];
  };
}
