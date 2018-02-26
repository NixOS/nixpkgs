{ stdenv, buildPythonPackage, fetchurl, pytest }:

buildPythonPackage rec {
  pname = "hyperlink";
  version = "18.0.0";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/h/hyperlink/${name}.tar.gz";
    sha256 = "f01b4ff744f14bc5d0a22a6b9f1525ab7d6312cb0ff967f59414bbac52f0a306";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test $out
  '';

  meta = with stdenv.lib; {
    description = "A featureful, correct URL for Python";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ apeschar ];
  };
}
