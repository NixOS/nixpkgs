{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2021.5.30";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-K792/UMpYBOLPvbdo93gVE8ny/hUbEWOYLrzcZF7qe4=";
  };

  pythonImportsCheck = [ "certifi" ];

  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    homepage = "https://certifi.io/";
    description = "Python package for providing Mozilla's CA Bundle";
    license = licenses.isc;
    maintainers = with maintainers; [ koral ];
  };
}
