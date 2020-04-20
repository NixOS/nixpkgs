{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
, nose
, pkgs
}:

buildPythonPackage rec {
  pname = "pycdio";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01b7vqqfry071p60sabydym7r3m3rxszyqpdbs1qi5rk2sfyblnn";
  };

  prePatch = ''
    substituteInPlace setup.py \
      --replace 'library_dirs=library_dirs' 'library_dirs=[dir.decode("utf-8") for dir in library_dirs]' \
      --replace 'include_dirs=include_dirs' 'include_dirs=[dir.decode("utf-8") for dir in include_dirs]' \
      --replace 'runtime_library_dirs=runtime_lib_dirs' 'runtime_library_dirs=[dir.decode("utf-8") for dir in runtime_lib_dirs]'
  '';

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
    homepage = "https://www.gnu.org/software/libcdio/";
    description = "Wrapper around libcdio (CD Input and Control library)";
    maintainers = with maintainers; [ rycee ];
    license = licenses.gpl3Plus;
  };

}
