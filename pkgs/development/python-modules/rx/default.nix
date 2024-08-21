{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
  nose,
}:

buildPythonPackage rec {
  pname = "rx";
  version = "3.2.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  # Use fetchPypi to avoid the updater script to migrate it to `reactivex` which
  # is being developed in the same repository
  src = fetchPypi {
    inherit version;
    pname = "Rx";
    sha256 = "b657ca2b45aa485da2f7dcfd09fac2e554f7ac51ff3c2f8f2ff962ecd963d91c";
  };

  nativeCheckInputs = [ nose ];

  doCheck = false; # PyPI tarball does not provides tests

  pythonImportsCheck = [ "rx" ];

  meta = {
    homepage = "https://github.com/ReactiveX/RxPY";
    description = "Reactive Extensions for Python";
    maintainers = with lib.maintainers; [ thanegill ];
    license = lib.licenses.asl20;
  };
}
