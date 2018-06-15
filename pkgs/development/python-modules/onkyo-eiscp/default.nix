{ stdenv, buildPythonPackage, fetchPypi
, docopt, netifaces }:

buildPythonPackage rec {
  pname = "onkyo-eiscp";
  version = "1.2.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cfcca6bc6c36992095f5aa4a15870a3ef89b9a26d991da2333891c2675d4ef1b";
  };

  propagatedBuildInputs = [ docopt netifaces ];

  meta = with stdenv.lib; {
    description = "Control Onkyo receivers over ethernet";
    homepage = https://github.com/miracle2k/onkyo-eiscp;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
