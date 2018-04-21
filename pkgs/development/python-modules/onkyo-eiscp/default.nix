{ stdenv, buildPythonPackage, fetchPypi
, docopt, netifaces }:

buildPythonPackage rec {
  pname = "onkyo-eiscp";
  version = "1.2.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qb5w2g2cnckq7psh92g1w3gf76437x1vwfhwnd247wshs5h7hxj";
  };

  propagatedBuildInputs = [ docopt netifaces ];

  meta = with stdenv.lib; {
    description = "Control Onkyo receivers over ethernet";
    homepage = https://github.com/miracle2k/onkyo-eiscp;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
