{ buildPythonPackage
, fetchPypi
, python
, pytestrunner
, gcc
, glib
, python3Packages
, pkgconfig
, stdenv
, cython
, libffi
, vips
,
}:

buildPythonPackage rec {

  pname = "pyvips";

  version = "2.1.11";

  src = fetchPypi {
    inherit pname version;
      sha256 = "1kknp9nx0vj9bj2vp0rxr177d3aahvjwj2q59pb76wvw2xnm542y";
  };

  checkInputs = [ pytestrunner pkgconfig ];

  buildInputs = [
                  vips
                  vips.dev
                  libffi
                  gcc
                  glib
                  python3Packages.pytestrunner
                  python3Packages.pkgconfig
                  python3Packages.cffi
                ];

  propagatedBuildInputs = [
                ];

  # Tests cannot import pyfftw. pyfftw works fine though.

  doCheck = false;

  postConfigure = ''
    export LDFLAGS="-L${vips.dev}/lib"
    export CFLAGS="-I${vips.dev}/include"
  '';

  meta = {
    description = "A python wrapper for libvips";
    homepage = "https://github.com/libvips/pyvips";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ ccellado ];
    platforms = stdenv.lib.platforms.unix;
  };
}
