{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, scipy
, pandas
, scikitlearn
, future
, tqdm
, cloudpickle
, decorator
, nose
, ipython
, ipyparallel
, matplotlib
}:

let
  # this package needs networkx 2.2 specifically
  networkx-2_2 = buildPythonPackage rec {
    pname = "networkx";
    version = "2.2";

    doCheck = false;
    propagatedBuildInputs = [
      decorator
    ];

    src = fetchPypi {
      inherit pname version;
      sha256 = "45e56f7ab6fe81652fb4bc9f44faddb0e9025f469f602df14e3b2551c2ea5c8b";
      extension = "zip";
    };
  };
in
  buildPythonPackage rec {
    pname = "hyperopt";
    version = "0.2.2";

    # checks not working at the moment
    # see https://github.com/hyperopt/hyperopt/issues/580
    doCheck = false;
    checkInputs = [ nose ipython ipyparallel matplotlib ];

    propagatedBuildInputs = [
      numpy scipy pandas scikitlearn networkx-2_2 future tqdm cloudpickle
    ];

    src = fetchPypi {
      inherit pname version;
      sha256 = "0mf4zligyhracyfx02ayrvdnxwxsbr912sfby167pgi3fy3vjyfb";
    };

    meta = with stdenv.lib; {
      homepage = "https://github.com/hyperopt/hyperopt";
      description = "Hyperopt is a Python library for serial and parallel optimization over awkward search spaces";
      license = licenses.bsd3;
      maintainers = [ maintainers.GuillaumeDesforges ];
    };
  }