{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2020.11.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f05def092c44fbf25834a51509ef6e631dc19765ab8a57b4e7ab85531f0a9cf4";
  };

  pythonImportsCheck = [ "certifi" ];

  dontUseSetuptoolsCheck = true;

  meta = {
    homepage = "https://certifi.io/";
    description = "Python package for providing Mozilla's CA Bundle";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ koral ];
  };
}
