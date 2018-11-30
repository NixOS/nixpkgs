{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, six
, paste
, PasteDeploy
, cheetah
, argparse
}:

buildPythonPackage rec {
  version = "1.7.5";
  pname = "PasteScript";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2b685be69d6ac8bc0fe6f558f119660259db26a15e16a4943c515fbee8093539";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ six paste PasteDeploy cheetah argparse ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A pluggable command-line frontend, including commands to setup package file layouts";
    homepage = http://pythonpaste.org/script/;
    license = licenses.mit;
  };

}
