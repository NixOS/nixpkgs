{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, scipy
, pandas
, networkx
, scikitlearn
, future
, tqdm
, cloudpickle
, decorator
, nose
, pytest
, ipython
, ipyparallel
, matplotlib
, lightgbm
, bson
, pyspark
}:

let
  # this package needs networkx 2.2 specifically
  networkx-2_2 = buildPythonPackage rec {
    pname = "networkx";
    version = "2.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "45e56f7ab6fe81652fb4bc9f44faddb0e9025f469f602df14e3b2551c2ea5c8b";
      extension = "zip";
    };
    
    propagatedBuildInputs = [
      decorator
    ];

    checkInputs = [
        nose
    ];
  };
in
  buildPythonPackage rec {
    pname = "hyperopt";
    version = "0.2.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1rp0rz6i7arczlq8dc3jyjp9y07789c3m1mz45lhhhcmzjnhwifz";
    };

    propagatedBuildInputs = [
      numpy
      scipy
      pandas
      scikitlearn
      networkx-2_2
      future
      tqdm
      cloudpickle
    ];

    # checks not working at the moment
    # see https://github.com/hyperopt/hyperopt/issues/580
    # doCheck = false;
    checkPhase = ''
        nosetests
    '';

    checkInputs = [
        nose
        pytest
        ipython
        ipyparallel
        matplotlib
        scikitlearn
        bson
        pyspark
    ];

    meta = with stdenv.lib; {
      homepage = "https://github.com/hyperopt/hyperopt";
      description = "Hyperopt is a Python library for serial and parallel optimization over awkward search spaces";
      license = licenses.bsd3;
      maintainers = [ maintainers.GuillaumeDesforges ];
    };
  }