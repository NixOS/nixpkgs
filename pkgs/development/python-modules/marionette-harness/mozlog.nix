{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, blessings
, mozterm
, six
, mozfile
}:

buildPythonPackage rec {
  pname = "mozlog";
  version = "5.0";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h1hgs13c1w0wvz60400i37m00077li1ky28j7kgx4bl75pkd3sw";
  };

  propagatedBuildInputs = [ blessings mozterm six ];

  checkInputs = [ mozfile ];

  meta = {
    description = "Mozilla logging library";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
