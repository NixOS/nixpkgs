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
  version = "4.0";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a9e84e44113ba3cfde217d4e941979d37445ee48166a79583f9fc1e74770d5e1";
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
