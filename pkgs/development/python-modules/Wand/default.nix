{ lib
, buildPythonPackage
, fetchPypi
, imagemagickBig
}:

buildPythonPackage rec {
  pname = "Wand";
  version = "0.6.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ebc01bccc25dba68414ab55b482341f9ad2b197d7f49d5e724f339bbf63fb6db";
  };

  postPatch = ''
    substituteInPlace wand/api.py --replace \
      "magick_home = os.environ.get('MAGICK_HOME')" \
      "magick_home = '${imagemagickBig}'"
  '';

  # tests not included with pypi release
  doCheck = false;

  passthru.imagemagick = imagemagickBig;

  meta = with lib; {
    description = "Ctypes-based simple MagickWand API binding for Python";
    homepage = "http://wand-py.org/";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ infinisil ];
  };
}
