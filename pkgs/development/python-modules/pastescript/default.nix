{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, six
, paste
, PasteDeploy
, cheetah
}:

buildPythonPackage rec {
  version = "2.0.2";
  pname = "PasteScript";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c03f249805538cc2328741ae8d262a9200ae1c993119b3d9bac4cd422cb476c0";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ six paste PasteDeploy cheetah ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A pluggable command-line frontend, including commands to setup package file layouts";
    homepage = http://pythonpaste.org/script/;
    license = licenses.mit;
  };

}
