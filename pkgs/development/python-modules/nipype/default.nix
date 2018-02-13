{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
# python dependencies
, click
, configparser ? null
, dateutil
, funcsigs
, future
, mock
, networkx
, nibabel
, numpy
, packaging
, prov
, psutil
, pydot
, pytest
, scipy
, simplejson
, traits
, xvfbwrapper
# other dependencies
, which
}:

assert !isPy3k -> configparser != null;

buildPythonPackage rec {
  pname = "nipype";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c14c6cae1f530f89d76fa8136d52488b1daf3a02179da65121b76eaf4a6f0ea";
  };

  doCheck = false;  # fails with TypeError: None is not callable
  checkInputs = [ which ];
  buildInputs = [ pytest mock ];  # required in installPhase
  propagatedBuildInputs = [
    click
    dateutil
    funcsigs
    future
    networkx
    nibabel
    numpy
    packaging
    prov
    psutil
    pydot
    scipy
    simplejson
    traits
    xvfbwrapper
  ] ++ stdenv.lib.optional (!isPy3k) [
    configparser
  ];

  meta = with stdenv.lib; {
    homepage = http://nipy.org/nipype/;
    description = "Neuroimaging in Python: Pipelines and Interfaces";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
}
