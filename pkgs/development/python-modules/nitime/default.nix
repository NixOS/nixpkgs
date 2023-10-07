{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, cython
, setuptools
, setuptools-scm
, wheel
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

  # Upstream wants to build against the oldest version of numpy possible, but
  # we only want to build against the most recent version.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "numpy==" "numpy>="
  '';

  nativeBuildInputs = [
    cython
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    matplotlib
    networkx
    nibabel
  ];

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
