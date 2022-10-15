{ lib
, buildPythonPackage
, fetchPypi
, imagemagickBig
}:

buildPythonPackage rec {
  pname = "Wand";
  version = "0.6.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Nz9KfyhmyGjDHOkQ4fmzapLRMmQKIAaOwXzqMoT+3Fc=";
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
