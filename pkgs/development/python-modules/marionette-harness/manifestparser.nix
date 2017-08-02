{ lib
, stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "manifestparser";
  version = "1.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06cnj682ynacwpi63k1427vbf7ydnwh3dchc4b11yw8ii25wbc5d";
  };

  propagatedBuildInputs = [ ];

  meta = {
    description = "Mozilla test manifest handling";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
