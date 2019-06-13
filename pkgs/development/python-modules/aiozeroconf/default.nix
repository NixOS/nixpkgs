{ stdenv
, buildPythonPackage
, fetchPypi
, netifaces
, isPy27
, python
}:

buildPythonPackage rec {
  pname = "aiozeroconf";
  version = "0.1.8";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "074plydm7sd113p3k0siihwwz62d3r42q3g83vqaffp569msknqh";
  };

  propagatedBuildInputs = [ netifaces ];

  meta = with stdenv.lib; {
    description = "A pure python implementation of multicast DNS service discovery";
    homepage = https://github.com/jstasiak/python-zeroconf;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ obadz ];
  };
}
