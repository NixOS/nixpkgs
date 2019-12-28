{ lib, buildPythonPackage, fetchPypi, aiohttp, future-fstrings, pythonOlder
, sqlalchemy, ruamel_yaml, CommonMark, lxml, fetchpatch
}:

buildPythonPackage rec {
  pname = "mautrix";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03m59d683nr547v5xr80wc3j07das2d2sc3i4bf03dpbkfg0h17w";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/tulir/mautrix-python/commit/ac46f3bb1bea11d22d8a486cc4821604c844da5e.patch";
      sha256 = "198g63s0iv8g1w22g4g5hb54y41ws82wraglibz33qhrwsfn8axn";
    })
  ];

  propagatedBuildInputs = [
    aiohttp
    future-fstrings

    # defined in optional-requirements.txt
    sqlalchemy
    ruamel_yaml
    CommonMark
    lxml
  ];

  disabled = pythonOlder "3.5";

  # no tests available
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/tulir/mautrix-python;
    description = "A Python 3 asyncio Matrix framework.";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nyanloutre ma27 ];
  };
}
