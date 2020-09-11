{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2020.6.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3";
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
