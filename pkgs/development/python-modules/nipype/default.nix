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
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "47f62fda3d6b9a37aa407a6b78c80e91240aa71e61191ed00da68b02839fe258";
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
