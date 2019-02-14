{ lib
, buildPythonPackage
, fetchPypi
, moznetwork
, mozprocess
}:

buildPythonPackage rec {
  pname = "mozdevice";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e22e52e4ea92a50b230ac911a4179056aa1fb1d682108e8c3dc66c6d6d329163";
  };

  propagatedBuildInputs = [ moznetwork mozprocess ];

  meta = {
    description = "Mozilla-authored device management";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
