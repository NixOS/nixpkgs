{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2020.4.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06b5gfs7wmmipln8f3z928d2mmx2j4b3x7pnqmj6cvmyfh8v7z2i";
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
