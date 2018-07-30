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
  version = "3.8";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "af3a3252bc58f8642a641601ba59096c22e4aa49cdc1ed4b0df2314f4f027f0d";
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
