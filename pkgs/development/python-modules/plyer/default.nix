{ lib, fetchPypi, buildPythonPackage, }:

buildPythonPackage rec {
  pname = "plyer";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jeOLF7xDjfNu7erNVGzwUwOrhxhVrwZp/E6N9R8q35Q=";
  };

  doCheck = false; # tests fail in Nix sandbox
  pythonImportsCheck = [ "plyer" ];

  meta = with lib; {
    description = "Platform-independent wrapper for platform-dependent APIs";
    homepage = "https://plyer.readthedocs.io/en/latest";
    license = licenses.mit;
    maintainers = with maintainers; [ vojta001 ];
  };
}
