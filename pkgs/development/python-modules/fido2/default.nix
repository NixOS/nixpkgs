{ lib
, buildPythonPackage
, fetchPypi
, six
, cryptography
, mock
, pyfakefs
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "fido2";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-K0tOYgwhAEQsIGeODpUa1tHvs7pcqOu3IMTI1UMpNnQ=";
  };

  propagatedBuildInputs = [ six cryptography ];

  nativeCheckInputs = [ unittestCheckHook mock pyfakefs ];

  unittestFlagsArray = [ "-v" ];

  pythonImportsCheck = [ "fido2" ];

  meta = with lib; {
    description = "Provides library functionality for FIDO 2.0, including communication with a device over USB.";
    homepage = "https://github.com/Yubico/python-fido2";
    license = licenses.bsd2;
    maintainers = with maintainers; [ prusnak ];
  };
}
