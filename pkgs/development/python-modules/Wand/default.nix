{ lib
, buildPythonPackage
, fetchPypi
, imagemagickBig
}:

buildPythonPackage rec {
  pname = "Wand";
  version = "0.6.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "540a2da5fb3ada1f0abf6968e0fa01ca7de6cd517f3be5c52d03a4fc8d54d75e";
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
