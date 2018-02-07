{ lib
, buildPythonPackage
, fetchPypi
, pytest
, datashape
, numpy
, pandas
, toolz
, multipledispatch
, networkx
}:

buildPythonPackage rec {
  pname = "odo";
  version= "0.5.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mh5k69d9ph9jd07jl9yqh78rbnh5cjspi1q530v3ml7ivjzz4p8";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ datashape numpy pandas toolz multipledispatch networkx ];

  checkPhase = ''
    py.test odo/tests
  '';

  meta = {
    homepage = https://github.com/ContinuumIO/odo;
    description = "Data migration utilities";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ fridh ];
  };
}