{ lib
, buildPythonPackage
, fetchPypi
, ipywidgets
, pythreejs
, ipywebrtc
, pillow
}:

buildPythonPackage rec {
  pname = "ipyvolume";
  version = "0.5.2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "Gcve6i2InNG7cPe4L4FIM60LPRFcgXHXt4YIUdj7vSY=";
  };
  propagatedBuildInputs = [ ipywidgets pythreejs ipywebrtc pillow ];
  doCheck = false; # tries to do some headless browsing
  pythonImportsCheck = [ "ipyvolume" ];
  meta = {
    description = "IPython widget for rendering 3d volumes and glyphs (e.g. scatter and quiver) in the Jupyter notebook";
    homepage = "https://github.com/maartenbreddels/ipyvolume";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cfhammill ];
  };
}
