{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "peppercorn";
  version = "0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "921cba5d51fa211e6da0fbd2120b9a98d663422a80f5bb669ad81ffb0909774b";
  };

  meta = with stdenv.lib; {
    description = "A library for converting a token stream into a data structure for use in web form posts";
    homepage = https://docs.pylonsproject.org/projects/peppercorn/en/latest/;
    maintainers = with maintainers; [ garbas domenkozar ];
    platforms = platforms.all;
  };

}
