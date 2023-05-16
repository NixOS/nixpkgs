{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, cython
<<<<<<< HEAD
, setuptools
, setuptools-scm
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
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

=======
  buildInputs = [ cython ];
  propagatedBuildInputs = [ numpy scipy matplotlib networkx nibabel ];

  nativeCheckInputs = [ pytestCheckHook ];
  doCheck = !stdenv.isDarwin;  # tests hang indefinitely
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [ "nitime" ];

  meta = with lib; {
    homepage = "https://nipy.org/nitime";
    description = "Algorithms and containers for time-series analysis in time and spectral domains";
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
