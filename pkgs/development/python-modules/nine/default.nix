{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "nine";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zrsbm0hajfvklkhgysp81hy632a3bdakp31m0lcpd9xbp5265zy";
  };

  meta = with stdenv.lib; {
    description = "Let's write Python 3 right now!";
    homepage = "https://github.com/nandoflorestan/nine";
    license = licenses.free;
  };

}
