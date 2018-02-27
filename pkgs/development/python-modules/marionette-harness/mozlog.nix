{ lib
, stdenv
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
  version = "3.7";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "414141131c4f5e7242e69a939d2b74f4ed8dbac12bef93eee4e7125cd1a131e9";
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
