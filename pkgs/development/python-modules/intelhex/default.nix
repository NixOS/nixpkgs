{ lib
, buildPythonPackage
, fetchPypi
, fetchurl
}:

buildPythonPackage rec {
  pname = "intelhex";
  version = "2.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k5l1mn3gv1vb0jd24ygxksx8xqr57y1ivgyj37jsrwpzrp167kw";
  };

  patches = [
    (fetchurl {
      url = https://github.com/bialix/intelhex/commit/f251aef214daa2116e15ff7f7dcec1639eb12d5b.patch;
      sha256 = "02i15qjmcz7mwbwvyj3agl5y7098rag2iwypdilkaadhbslsl9b9";
    })
  ];

  meta = {
    homepage = https://github.com/bialix/intelhex;
    description = "Python library for Intel HEX files manipulations";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pjones ];
  };
}
