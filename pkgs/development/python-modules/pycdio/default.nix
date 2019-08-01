{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
, nose
, pkgs
, isPy27
}:

buildPythonPackage rec {
  pname = "pycdio";
  version = "2.0.0";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a1h0lmfl56a2a9xqhacnjclv81nv3906vdylalybxrk4bhrm3hj";
  };

  prePatch = "sed -i -e '/DRIVER_BSDI/d' pycdio.py";

  preConfigure = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ nose pkgs.pkgconfig pkgs.swig ];
  buildInputs = [ setuptools pkgs.libcdio ]
    ++ stdenv.lib.optional stdenv.isDarwin pkgs.libiconv;

  # Run tests using nosetests but first need to install the binaries
  # to the root source directory where they can be found.
  checkPhase = ''
    ./setup.py install_lib -d .
    nosetests
  '';

  meta = with stdenv.lib; {
    homepage = https://www.gnu.org/software/libcdio/;
    description = "Wrapper around libcdio (CD Input and Control library)";
    maintainers = with maintainers; [ rycee ];
    license = licenses.gpl3Plus;
  };

}
