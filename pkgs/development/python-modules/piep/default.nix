{ stdenv
, buildPythonPackage
, fetchPypi
, pygments
, isPy3k
}:

buildPythonPackage rec {
  version = "0.8.0";
  pname = "piep";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wgkg1kc28jpya5k4zvbc9jmpa60b3d5c3gwxfbp15hw6smyqirj";
  };

  propagatedBuildInputs = [ pygments ];

  meta = with stdenv.lib; {
    description = "Bringing the power of python to stream editing";
    homepage = https://github.com/timbertson/piep;
    maintainers = with maintainers; [ timbertson ];
    license = licenses.gpl3;
  };

}
