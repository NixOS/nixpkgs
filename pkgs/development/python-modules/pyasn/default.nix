{ lib, buildPythonPackage, fetchPypi, }:

buildPythonPackage rec {
  pname = "pyasn";
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6UK1SRY2Pse4tw6urs0OtOQe8bz0ojl7KabXFfzN+SU=";
  };

  doCheck = false; # Tests require internet connection which wont work

  pythonImportsCheck = [ "pyasn" ];

  meta = with lib; {
    description = "Offline IP address to Autonomous System Number lookup module";
    homepage = "https://github.com/hadiasghari/pyasn";
    license = with licenses; [ bsdOriginal mit ];
    maintainers = with maintainers; [ onny ];
  };
}
