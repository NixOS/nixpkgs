{ lib
, bottleneck
, buildPythonPackage
, fetchPypi
, jellyfish
, joblib
, networkx
, numexpr
, numpy
, pandas
, pyarrow
, pytest
, scikit-learn
, scipy
, pythonOlder
}:

buildPythonPackage rec {
  pname = "recordlinkage";
  version = "0.15";

  disabled = pythonOlder "3.7";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-aIrx54vnf85I/Kit/4njg/VIOu6H0SE7NdQ1GbeP8Cc=";
  };

  propagatedBuildInputs = [
    pyarrow
    jellyfish
    numpy
    pandas
    scipy
    scikit-learn
    joblib
    networkx
    bottleneck
    numexpr
  ];

  # pytestCheckHook does not work
  # Reusing their CI setup which involves 'rm -rf recordlinkage' in preCheck phase do not work too.
  nativeCheckInputs = [ pytest ];

  pythonImportsCheck = [ "recordlinkage" ];

  meta = with lib; {
    description = "Library to link records in or between data sources";
    homepage = "https://recordlinkage.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = [ maintainers.raitobezarius ];
  };
}
