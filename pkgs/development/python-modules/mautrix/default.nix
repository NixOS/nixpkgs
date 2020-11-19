{ lib, buildPythonPackage, fetchPypi, aiohttp, future-fstrings, pythonOlder
, sqlalchemy, ruamel_yaml, CommonMark, lxml, fetchpatch
}:

buildPythonPackage rec {
  pname = "mautrix";
  version = "0.5.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hqg32n7pmjhap0ybfcf05zgfcyyirb4fm1m7gf44dwh40da6qz0";
  };

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
    homepage = "https://github.com/tulir/mautrix-python";
    description = "A Python 3 asyncio Matrix framework.";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nyanloutre ma27 ];
  };
}
