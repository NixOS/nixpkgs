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
    hash = "sha256-rbDFi4gRcR/CIgyyNiC3zR+39hEkzGHi5UxZL5CRlhk=";
  };

  propagatedBuildInputs = [ ];

  meta = {
    description = "Mozilla test manifest handling";
    homepage = "https://wiki.mozilla.org/Auto-tools/Projects/Mozbase";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
