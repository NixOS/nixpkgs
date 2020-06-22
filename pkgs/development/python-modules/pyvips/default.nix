{ buildPythonPackage, fetchPypi, python, pytestrunner, gcc, glib
, python3Packages, pkgconfig, stdenv, cython, libffi, vips, }:

buildPythonPackage rec {

  pname = "pyvips";

  version = "2.1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kknp9nx0vj9bj2vp0rxr177d3aahvjwj2q59pb76wvw2xnm542y";
  };

  outputs = [ "out" "dev" ];

  checkInputs = [ pytestrunner pkgconfig ];

  nativeBuildInputs = [ vips.dev libffi gcc glib.dev glib ];

  buildInputs = [
    python3Packages.pytestrunner
    python3Packages.pkgconfig
    python3Packages.cffi
    vips.dev
    glib.dev
  ];

  propagatedBuildInputs = [ ];

  doCheck = false;

  pythonImportsCheck = [ "pyvips" ];

  postConfigure =
    "\n    export LD_LIBRARY_PATH=${glib.out}/lib:${vips.out}/lib\n  ";

  meta = {
    description = "A python wrapper for libvips";
    homepage = "https://github.com/libvips/pyvips";
    license = stdenv.lib.licenses.bsd3;
    #maintainers = with stdenv.lib.maintainers; [ ccellado ];
    platforms = stdenv.lib.platforms.unix;
  };
}
