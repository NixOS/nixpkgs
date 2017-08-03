{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, mozlog
, mozinfo
}:

buildPythonPackage rec {
  pname = "moznetwork";
  version = "0.27";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09ypx5wif0mly6fk3491nlzg8whg6qw24x7h9w70hykdqindbh2s";
  };

  propagatedBuildInputs = [ mozlog mozinfo ]; 

  meta = {
    description = "Network utilities for Mozilla testing";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
