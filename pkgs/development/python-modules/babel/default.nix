{ stdenv, lib, buildPythonPackage, fetchPypi, pythonOlder, pytz, pytestCheckHook, freezegun }:

buildPythonPackage rec {
  pname = "babel";
  version = "2.12.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Babel";
    inherit version;
    sha256 = "sha256-zC2ZmZzQHURCCuclohyeNxGzqtx5dtYUf2IthYGWNFU=";
  };

  propagatedBuildInputs = lib.optional (pythonOlder "3.9") pytz;

  nativeCheckInputs = [ pytestCheckHook freezegun ];

  meta = with lib; {
    homepage = "https://babel.pocoo.org/";
    description = "Collection of internationalizing tools";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
