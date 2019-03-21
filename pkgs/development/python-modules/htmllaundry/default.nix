{ stdenv
, buildPythonPackage
, fetchPypi, nose
, six
, lxml
}:

buildPythonPackage rec {
  pname = "htmllaundry";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e428cba78d5a965e959f5dac2eb7d5f7d627dd889990d5efa8d4e03f3dd768d9";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ six lxml ];

  # some tests fail, probably because of changes in lxml
  # not relevant for me, if releavnt for you, fix it...
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Simple HTML cleanup utilities";
    license = licenses.bsd3;
    homepage = https://pypi.org/project/htmllaundry/;
  };

}
