{ stdenv
, buildPythonPackage
, fetchurl
, nose
, pkgs
, numpy
}:

buildPythonPackage rec {
  pname = "python-imread";
  version = "0.6";

  src = pkgs.fetchurl {
    url = "https://github.com/luispedro/imread/archive/release-${version}.tar.gz";
    sha256 = "0i14bc67200zhzxc41g5dfp2m0pr1zaa2gv59p2va1xw0ji2dc0f";
  };

  nativeBuildInputs = [ pkgs.pkgconfig ];
  buildInputs = [ nose pkgs.libjpeg pkgs.libpng pkgs.libtiff pkgs.libwebp ];
  propagatedBuildInputs = [ numpy ];

  meta = with stdenv.lib; {
    description = "Python package to load images as numpy arrays";
    homepage = https://imread.readthedocs.io/en/latest/;
    maintainers = with maintainers; [ luispedro ];
    license = licenses.mit;
    platforms = platforms.unix;
  };

}
