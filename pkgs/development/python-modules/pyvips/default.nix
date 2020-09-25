{ buildPythonPackage, fetchPypi, python, pytestrunner, gcc, glib, cffi
, python3Packages, pkgconfig, stdenv, vips, lib}:

buildPythonPackage rec {

  pname = "pyvips";

  version = "2.1.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pg0dxhxgi2m7bb5bi5wpx9hgnbi8ws1bz6w2dldbhi52pizghl4";
  };

  buildInputs = [
    python3Packages.pytestrunner
    python3Packages.pkgconfig
  ];

  propagatedBuildInputs = [
    python3Packages.cffi
  ];

  doCheck = false;

  pythonImportsCheck = [ "pyvips" ];

  preConfigure = ''
    export PKG_CONFIG_PATH="${vips.dev}/lib/pkgconfig:${glib.dev}/lib/pkgconfig"
  '';

  meta = with lib; {
    description = "A python wrapper for libvips";
    homepage = "https://github.com/libvips/pyvips";
    license = licenses.mit;
    maintainers = with maintainers; [ ccellado ];
  };
}
