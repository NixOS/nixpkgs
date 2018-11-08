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
  version = "0.2.2.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d937d817e534efc54eaee2fc4c0e70b48fcd81e1528cd6425f22178704681dc3";
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
