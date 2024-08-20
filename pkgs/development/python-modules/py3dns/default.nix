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
    sha256 = "1r25f0ys5p37bhld7m7n4gb0lrysaym3w318w2f8bncq7r3d81qz";
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
