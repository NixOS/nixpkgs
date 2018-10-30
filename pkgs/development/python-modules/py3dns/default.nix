{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "py3dns";
  version = "3.1.1a";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z0qmx9j1ivpgg54gqqmh42ljnzxaychc5inz2gbgv0vls765smz";
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
