{ lib
, buildPythonPackage, fetchPypi
, pkg-config, cython, docutils
, kivy-garden
, mesa, mtdev, SDL2, SDL2_image, SDL2_ttf, SDL2_mixer, gst_all_1
, pillow, requests, pygments
}:

buildPythonPackage rec {
  pname = "Kivy";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n0j9046vgjncy50v06r3wcg3q2l37jp8n0cznr64dz48kml8pnj";
  };

  nativeBuildInputs = [
    pkg-config
    cython
    docutils
  ];

  buildInputs = [
    mesa
    mtdev
    SDL2
    SDL2_image
    SDL2_ttf
    SDL2_mixer

    # NOTE: The degree to which gstreamer actually works is unclear
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  propagatedBuildInputs = [
    kivy-garden
    pillow
    pygments
    requests
  ];

  KIVY_NO_CONFIG = 1;
  KIVY_NO_ARGS = 1;
  KIVY_NO_FILELOG = 1;

  postPatch = ''
    substituteInPlace kivy/lib/mtdev.py \
      --replace "LoadLibrary('libmtdev.so.1')" "LoadLibrary('${mtdev}/lib/libmtdev.so.1')"
  '';

  /*
    We cannot run tests as Kivy tries to import itself before being fully
    installed.
  */
  doCheck = false;
  pythonImportsCheck = [ "kivy" ];

  meta = with lib; {
    description = "Library for rapid development of hardware-accelerated multitouch applications.";
    homepage = "https://pypi.python.org/pypi/kivy";
    license = licenses.mit;
    maintainers = with maintainers; [ risson ];
  };
}
