{ lib, buildPythonPackage, fetchPypi, pythonOlder
, pycryptodomex }:

buildPythonPackage rec {
  pname = "pyctr";
  version = "0.7.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N5jRGLwALhv6uzaw1E8vQwut4qpnJ+u5PdsCX2T0pcA=";
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
