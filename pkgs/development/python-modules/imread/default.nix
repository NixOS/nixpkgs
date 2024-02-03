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
  version = "0.7.5";

  src = fetchPypi {
    inherit version;
    pname = "imread";
    sha256 = "sha256-GiWpA128GuLlbBW1CQQHHVVeoZfu9Yyh2RFzSdtHDbc=";
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
