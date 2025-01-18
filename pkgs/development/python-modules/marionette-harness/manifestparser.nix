{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "manifestparser";
  version = "1.1";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "06cnj682ynacwpi63k1427vbf7ydnwh3dchc4b11yw8ii25wbc5d";
  };

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = "Mozilla test manifest handling";
    homepage = "https://wiki.mozilla.org/Auto-tools/Projects/Mozbase";
    license = licenses.mpl20;
    maintainers = with maintainers; [ raskin ];
  };
}
