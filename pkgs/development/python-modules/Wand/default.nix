{ stdenv
, buildPythonPackage
, fetchPypi
, imagemagick7Big
}:

buildPythonPackage rec {
  pname = "Wand";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d21429288fe0de63d829dbbfb26736ebaed9fd0792c2a0dc5943c5cab803a708";
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
