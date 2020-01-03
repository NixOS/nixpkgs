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
  version = "4.2.0";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "dc85cfb9d47af6811f2367f471de7028c36204340c5e68a928115409ea75d9a9";
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
