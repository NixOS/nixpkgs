{ stdenv
, buildPythonPackage
, fetchPypi
, pyramid
}:

buildPythonPackage rec {
  pname = "pyramid_multiauth";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lq292qakrm4ixi4vaif8dqywzj08pn6qy0wi4gw28blh39p0msk";
  };

  propagatedBuildInputs = [ pyramid ];

  meta = with stdenv.lib; {
    description = "Authentication policy for Pyramid that proxies to a stack of other authentication policies";
    homepage = https://github.com/mozilla-services/pyramid_multiauth;
    license = licenses.mpl20;
  };

}
