{ stdenv
, buildPythonPackage
, fetchPypi
, imagemagick7Big
}:

buildPythonPackage rec {
  pname = "Wand";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jm1jdrlmm0gkvaxhbwwqic48vfgv8d0j99y90calnjrid3hwi35";
  };

  postPatch = ''
    substituteInPlace wand/api.py --replace \
      "magick_home = os.environ.get('MAGICK_HOME')" \
      "magick_home = '${imagemagick7Big}'"
  '';

  # tests not included with pypi release
  doCheck = false;

  passthru.imagemagick = imagemagick7Big;

  meta = with stdenv.lib; {
    description = "Ctypes-based simple MagickWand API binding for Python";
    homepage = "http://wand-py.org/";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ infinisil ];
  };
}
