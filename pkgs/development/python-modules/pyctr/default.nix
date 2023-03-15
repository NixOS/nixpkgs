{ lib, buildPythonPackage, fetchPypi, pythonOlder
, pycryptodomex }:

buildPythonPackage rec {
  pname = "pyctr";
  version = "0.6.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-05lMcsIeJIHI3LwHQTjr4M+bn1FG+GQscuGq34XxjK8=";
  };

  propagatedBuildInputs = [ pycryptodomex ];

  pythonImportsCheck = [ "pyctr" ];

  meta = with lib; {
    description = "Python library to interact with Nintendo 3DS files";
    license = licenses.mit;
    maintainers = with maintainers; [ rileyinman ];
    homepage = "https://github.com/ihaveamac/pyctr";
  };
}
