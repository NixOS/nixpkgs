{ lib
, buildPythonPackage
, fetchPypi
, mozlog
, mozinfo
}:

buildPythonPackage rec {
  pname = "moznetwork";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ws20l4ggb6mj7ycwrk5h7hj1jmj3mj0ca48k5jzsa4n042ahwrd";
  };

  propagatedBuildInputs = [ mozlog mozinfo ]; 

  meta = {
    description = "Network utilities for Mozilla testing";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
