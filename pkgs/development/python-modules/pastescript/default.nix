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
  version = "3.0.0";
  pname = "PasteScript";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9d4d98df8606ad3bfa77be4722207d1a53a0fbcc714ee75d0fcd8a5c3f775c3";
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
