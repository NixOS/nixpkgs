{ lib
, stdenv
, fetchpatch
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, tdlib
}:

buildPythonPackage rec {
  pname = "python-telegram";
  version = "0.15.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Na2NIiVgYexKbEqjN58hfkgxwFdCTL7Z7D3WEhL4wXA=";
  };

  patches = [
    # Search for the system library first, and fallback to the embedded one if the system was not found
    (fetchpatch {
      url = "https://github.com/alexander-akhmetov/python-telegram/commit/b0af0985910ebb8940cff1b92961387aad683287.patch";
      hash = "sha256-ZqsntaiC2y9l034gXDMeD2BLO/RcsbBII8FomZ65/24=";
    })
  ];

  postPatch = ''
    # Remove bundled libtdjson
    rm -fr telegram/lib

    substituteInPlace telegram/tdjson.py \
      --replace "ctypes.util.find_library(\"libtdjson\")" \
                "\"${tdlib}/lib/libtdjson${stdenv.hostPlatform.extensions.sharedLibrary}\""
  '';

  propagatedBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "telegram.client"
  ];

  meta = with lib; {
    description = "Python client for the Telegram's tdlib";
    homepage = "https://github.com/alexander-akhmetov/python-telegram";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
