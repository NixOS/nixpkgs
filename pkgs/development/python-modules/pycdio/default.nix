{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  nose,
  pkgs,
}:

buildPythonPackage rec {
  pname = "pycdio";
  version = "2.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "61734db8c554b7b1a2cb2da2e2c15d3f9f5973a57cfb06f8854c38029004a9f8";
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

  nativeBuildInputs = [
    nose
    pkgs.pkg-config
    pkgs.swig
  ];
  buildInputs = [
    setuptools
    pkgs.libcdio
  ] ++ lib.optional stdenv.isDarwin pkgs.libiconv;

  # Run tests using nosetests but first need to install the binaries
  # to the root source directory where they can be found.
  checkPhase = ''
    ./setup.py install_lib -d .
    nosetests
  '';

  meta = with lib; {
    homepage = "https://www.gnu.org/software/libcdio/";
    description = "Wrapper around libcdio (CD Input and Control library)";
    license = licenses.gpl3Plus;
  };
}
