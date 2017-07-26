{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, mozinfo
}:

buildPythonPackage rec {
  pname = "moztest";
  version = "0.8";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pg9pqq4xnn14k1jqbyqg81zag2v66y725537v6hixi41yiqkdas";
  };

  propagatedBuildInputs = [ mozinfo ];

  meta = {
    description = "Mozilla test result storage and output";
    homepage = "https://wiki.mozilla.org/Auto-tools/Projects/Mozbase";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
