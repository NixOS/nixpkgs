{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, cython
, numpy
, scipy
, matplotlib
, networkx
, nibabel
}:

buildPythonPackage rec {
  pname = "nitime";
  version = "0.10.1";
  disabled = pythonOlder "3.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NnoVrSt6MTTcNup1e+/1v5JoHCYcycuQH4rHLzXJt+Y=";
  };

  buildInputs = [ cython ];
  propagatedBuildInputs = [ numpy scipy matplotlib networkx nibabel ];

  nativeCheckInputs = [ pytestCheckHook ];
  doCheck = !stdenv.isDarwin;  # tests hang indefinitely
  pythonImportsCheck = [ "nitime" ];

  meta = with lib; {
    homepage = "https://nipy.org/nitime";
    description = "Algorithms and containers for time-series analysis in time and spectral domains";
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
