{ lib
, buildPythonPackage
, fetchPypi
, cloudpickle
, dask
, numpy, toolz # dask[array]
, multipledispatch
, setuptools-scm
, scipy
, scikit-learn
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "0.2.0";
  pname = "dask-glm";

  src = fetchPypi {
    inherit pname version;
    sha256 = "58b86cebf04fe5b9e58092e1c467e32e60d01e11b71fdc628baaa9fc6d1adee5";
  };

  nativeBuildInputs = [ setuptools-scm ];
  checkInputs = [ pytestCheckHook ];
  propagatedBuildInputs = [ cloudpickle dask numpy toolz multipledispatch scipy scikit-learn ];

  meta = with lib; {
    homepage = "https://github.com/dask/dask-glm/";
    description = "Generalized Linear Models with Dask";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
