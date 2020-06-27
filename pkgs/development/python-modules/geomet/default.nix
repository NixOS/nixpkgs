{ stdenv
, buildPythonPackage
, fetchPypi
, click
, six
}:

buildPythonPackage rec {
  pname = "geomet";
  version = "0.2.1.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15bys5hmfq18a2jpmch8x1szw9qwcjfbdzdysfmzrjwqqbvm9mwi";
  };

  propagatedBuildInputs = [ click six ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/geomet/geomet";
    license = licenses.asl20;
    description = "Convert GeoJSON to WKT/WKB (Well-Known Text/Binary), and vice versa.";
    maintainers = with maintainers; [ turion ];
  };

}
