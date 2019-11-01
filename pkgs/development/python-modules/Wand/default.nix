{ stdenv
, buildPythonPackage
, fetchPypi
, imagemagick7Big
}:

buildPythonPackage rec {
  pname = "Wand";
  version = "0.5.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wvqzppflph3fkgkyv3k11ga28fv1g1bz8sbf227d7pql8c6ia8k";
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
