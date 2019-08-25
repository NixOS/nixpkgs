{ stdenv
, buildPythonPackage
, fetchPypi
, imagemagick7Big
}:

buildPythonPackage rec {
  pname = "Wand";
  version = "0.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "126gpx6zj7fpx87v1qgicpfdahmmkqqmd2a8abllq0jlckrmjsyh";
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
    homepage = http://wand-py.org/;
    license = [ licenses.mit ];
    maintainers = with maintainers; [ infinisil ];
  };
}
