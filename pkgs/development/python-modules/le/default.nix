{ stdenv
, buildPythonPackage
, fetchurl
, isPy3k
, simplejson
, psutil
}:

buildPythonPackage rec {
  pname = "le";
  version = "1.4.29";

  src = fetchurl {
    url = "https://github.com/logentries/le/archive/v${version}.tar.gz";
    sha256 = "d29738937cb6e714b6ec2ae74b66b1983482ffd54b4faa40767af18509521d4c";
  };

  disabled = isPy3k;

  doCheck = false;

  propagatedBuildInputs = [ simplejson psutil ];

  meta = with stdenv.lib; {
    homepage = https://github.com/rapid7/le;
    description = "Logentries agent";
    license = licenses.mit;
  };

}
