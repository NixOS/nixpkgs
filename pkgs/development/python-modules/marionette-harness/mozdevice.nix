{ lib
, buildPythonPackage
, fetchPypi
, moznetwork
, mozprocess
}:

buildPythonPackage rec {
  pname = "mozdevice";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0026241bff3ad10a73fe24eb4f59c1313c94e5950f397b2f6b8cc4e4dfbfdd73";
  };

  propagatedBuildInputs = [ moznetwork mozprocess ];

  meta = {
    description = "Mozilla-authored device management";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
