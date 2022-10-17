{ lib
, buildPythonPackage
, fetchPypi
, nose
, pkg-config
, libjpeg
, libpng
, libtiff
, libwebp
, numpy
}:

buildPythonPackage rec {
  pname = "python-imread";
  version = "0.7.4";

  src = fetchPypi {
    inherit version;
    pname = "imread";
    sha256 = "0kvlpy62vc16i0mysv1b2gv746in41q75hb815q6h8d227psv1q4";
  };


  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ nose libjpeg libpng libtiff libwebp ];
  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    description = "Python package to load images as numpy arrays";
    homepage = "https://imread.readthedocs.io/en/latest/";
    maintainers = with maintainers; [ luispedro ];
    license = licenses.mit;
    platforms = platforms.unix;
  };

}
