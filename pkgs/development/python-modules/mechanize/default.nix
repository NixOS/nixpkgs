{ lib
, buildPythonPackage
, fetchPypi
, html5lib
}:

buildPythonPackage rec {
  pname = "mechanize";
  version = "0.4.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XoasB3c1fgBusEzSj37Z+BHUjf+mA9OJGsbSuSKA3JE=";
  };

  propagatedBuildInputs = [ html5lib ];

  doCheck = false;

  meta = with lib; {
    description = "Stateful programmatic web browsing in Python";
    homepage = "https://github.com/python-mechanize/mechanize";
    license = "BSD-style";
  };

}
