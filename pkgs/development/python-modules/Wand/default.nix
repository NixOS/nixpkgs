{ lib
, buildPythonPackage
, fetchPypi
, imagemagickBig
}:

buildPythonPackage rec {
  pname = "Wand";
  version = "0.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec981b4f07f7582fc564aba8b57763a549392e9ef8b6a338e9da54cdd229cf95";
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
