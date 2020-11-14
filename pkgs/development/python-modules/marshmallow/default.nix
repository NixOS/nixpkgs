{ lib, buildPythonPackage, fetchPypi
, dateutil, simplejson, isPy27, pytest
, pytz
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "3.9.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "73facc37462dfc0b27f571bdaffbef7709e19f7a616beb3802ea425b07843f4e";
  };

  propagatedBuildInputs = [ dateutil simplejson ];

  checkInputs = [ pytest pytz ];

  pythonImportCheck = [ "marshmallow" ];

  meta = with lib; {
    homepage = "https://github.com/marshmallow-code/marshmallow";
    description = "lightweight library for converting complex objects to and from simple Python datatypes.";
    license = licenses.mit;
    maintainers = with maintainers; [ freezeboy ];
  };
}
