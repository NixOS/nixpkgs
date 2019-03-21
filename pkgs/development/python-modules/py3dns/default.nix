{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "py3dns";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e88c0648c4d38a880f08aeb05a6e5cb48b8ce2602d381caafc6c71698ee3c21";
  };

  preConfigure = ''
    sed -i \
      -e '/import DNS/d' \
      -e 's/DNS.__version__/"${version}"/g' \
      setup.py
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python 3 DNS library";
    homepage = https://launchpad.net/py3dns;
    license = licenses.psfl;
  };

}
