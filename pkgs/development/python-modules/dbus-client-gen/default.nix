{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dbus-client-gen";
  version = "0.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DrpIeB6kMXPP6PfCjyx7Lsi8yyvwSl9k1nnUGtvVGKg=";
  };

  meta = with lib; {
    description = "A Python Library for Generating D-Bus Client Code";
    homepage = "https://github.com/stratis-storage/dbus-client-gen";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
