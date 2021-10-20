{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pycairo
, pygobject2
, pkgs
}:

buildPythonPackage rec {
  pname = "pypoppler";
  version = "0.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "47e6ac99e5b114b9abf2d1dd1bca06f22c028d025432512989f659142470810f";
  };

  NIX_CFLAGS_COMPILE="-I${pkgs.poppler.dev}/include/poppler/";
  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.poppler.dev ];
  propagatedBuildInputs = [ pycairo pygobject2 ];

  patches = [
    ./pypoppler-0.39.0.patch
    ./pypoppler-poppler.c.patch
  ];

  # Not supported.
  disabled = isPy3k;

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    homepage = "https://code.launchpad.net/~mriedesel/poppler-python/main";
    description = "Python bindings for poppler-glib, unofficial branch including bug fixes, and removal of gtk dependencies";
    license = licenses.gpl2;
  };

}
