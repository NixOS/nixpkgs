{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, mozinfo
}:

buildPythonPackage rec {
  pname = "mozprocess";
  version = "0.25";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lfflwjkwvc8bqvsgdib3b78w2pms8nharh3sc3zgsrmqb1mbzks";
  };

  propagatedBuildInputs = [ mozinfo ];

  meta = {
    description = "Mozilla-authored process handling";
    homepage = "https://wiki.mozilla.org/Auto-tools/Projects/Mozbase";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
