{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, unidecode
}:

buildPythonPackage rec {
  pname = "pyaml";
<<<<<<< HEAD
  version = "23.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-s/mzgzUyfTIUyIg0kwA3OGwP5EV+GuGXGcVvqiOSIr0=";
=======
  version = "21.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6519fee13bf06e3bb3f20cacdea8eba9140385a7c2546df5dbae4887f768383";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  nativeCheckInputs = [
    unidecode
  ];

  pythonImportsCheck = [ "pyaml" ];

  meta = with lib; {
    description = "PyYAML-based module to produce pretty and readable YAML-serialized data";
    homepage = "https://github.com/mk-fg/pretty-yaml";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ];
  };
}
