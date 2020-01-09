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
  version = "3.2.0";
  pname = "PasteScript";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9b0f5c0f1c6a510a353fa7c3dc4fdaab9071462d60d24573de76a001fbc172ac";
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
