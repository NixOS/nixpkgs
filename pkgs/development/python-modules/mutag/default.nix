{ lib
, buildPythonPackage
, fetchgit
, isPy3k
, pyparsing
}:

buildPythonPackage {
  pname = "mutag";
  version = "0.0.2-2ffa0258ca";
  disabled = ! isPy3k;

  src = fetchgit {
    url = "https://github.com/aroig/mutag.git";
    sha256 = "0axdnwdypfd74a9dnw0g25m16xx1yygyl828xy0kpj8gyqdc6gb1";
    rev = "2ffa0258cadaf79313241f43bf2c1caaf197d9c2";
  };

  propagatedBuildInputs = [ pyparsing ];

  meta = with lib; {
    homepage = "https://github.com/aroig/mutag";
    description = "A script to change email tags in a mu indexed maildir";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };

}
