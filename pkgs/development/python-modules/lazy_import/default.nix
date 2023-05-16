{ lib, buildPythonPackage, fetchPypi
<<<<<<< HEAD
, pytestCheckHook
, pytest-forked
, py
, python
=======
, pytest
, pytest-xdist
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, six }:

buildPythonPackage rec {
  pname = "lazy_import";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gca9xj60qr3aprj9qdc66crr4r7hl8wzv6gc9y40nclazwawj91";
  };

  nativeCheckInputs = [
<<<<<<< HEAD
    pytestCheckHook
    pytest-forked
    py
=======
    pytest
    pytest-xdist
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    six
  ];

<<<<<<< HEAD
  preCheck = ''
    # avoid AttributeError: module 'py' has no attribute 'process'
    export PYTHONPATH=${py}/${python.sitePackages}:$PYTHONPATH
  '';

  pytestFlagsArray = [
    "--forked"
  ];

  meta = with lib; {
    description = "A set of functions that load modules, and related attributes, in a lazy fashion";
    homepage = "https://github.com/mnmelo/lazy_import";
    license = licenses.gpl3Plus;
    maintainers = [ ];
=======
  checkPhase = ''
    cd lazy_import
    pytest --boxed
  '';

  meta = with lib; {
    description = "lazy_import provides a set of functions that load modules, and related attributes, in a lazy fashion.";
    homepage = "https://github.com/mnmelo/lazy_import";
    license = licenses.gpl3;
    maintainers = [ maintainers.marenz ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
