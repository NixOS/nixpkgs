{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, decorator
, imageio
, isPy3k
, tqdm
}:

buildPythonPackage rec {
  pname = "moviepy";
  version = "0.2.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jrdpnzyk373zlh8lvjdabyvljz3sahshbdgbpk6w9vx5hfacvjk";
  };

  # No tests
  doCheck = false;
  propagatedBuildInputs = [ numpy decorator imageio tqdm ];

  meta = with stdenv.lib; {
    description = "Video editing with Python";
    homepage = http://zulko.github.io/moviepy/;
    license = licenses.mit;
  };

}
