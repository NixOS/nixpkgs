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
  version = "0.1.0";
  pname = "dask-glm";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a38d17538558fe6a3457cd67eed0a90a5dff51a9eaebb496efb68fc432ed89a";
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
