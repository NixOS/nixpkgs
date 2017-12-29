{ stdenv, buildPythonPackage, fetchurl, pytest }:

buildPythonPackage rec {
  pname = "hyperlink";
  version = "17.3.1";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/h/hyperlink/${name}.tar.gz";
    sha256 = "bc4ffdbde9bdad204d507bd8f554f16bba82dd356f6130cb16f41422909c33bc";
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
