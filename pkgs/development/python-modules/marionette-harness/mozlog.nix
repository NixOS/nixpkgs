{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, blessings
, mozfile
}:

buildPythonPackage rec {
  pname = "mozlog";
  version = "3.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m4d9i1kzcmkhipfd5czv05f2s84j1byx3cv4y2irjmwq5v6cyiq";
  };

  propagatedBuildInputs = [ blessings mozfile ]; 

  meta = {
    description = "Mozilla logging library";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
