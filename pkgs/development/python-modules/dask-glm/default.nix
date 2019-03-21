{ stdenv
, buildPythonPackage
, fetchPypi
, cloudpickle
, dask
, numpy, toolz # dask[array]
, multipledispatch
, scipy
, scikitlearn
, pytest
}:

buildPythonPackage rec {
  version = "0.2.0";
  pname = "dask-glm";

  src = fetchPypi {
    inherit pname version;
    sha256 = "58b86cebf04fe5b9e58092e1c467e32e60d01e11b71fdc628baaa9fc6d1adee5";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ cloudpickle dask numpy toolz multipledispatch scipy scikitlearn ];

  checkPhase = ''
    py.test dask_glm
  '';

  meta = with stdenv.lib; {
    homepage = http://github.com/dask/dask-glm/;
    description = "Generalized Linear Models with Dask";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
