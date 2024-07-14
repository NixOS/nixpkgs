{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "py3dns";
  version = "3.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HwfURj6Y2YWc4CgMPqpX2mcK1iP21NMoXGfcoj1wReQ=";
  };

  preConfigure = ''
    sed -i \
      -e '/import DNS/d' \
      -e 's/DNS.__version__/"${version}"/g' \
      setup.py
  '';

  doCheck = false;

  meta = with lib; {
    description = "Python 3 DNS library";
    homepage = "https://launchpad.net/py3dns";
    license = licenses.psfl;
  };
}
