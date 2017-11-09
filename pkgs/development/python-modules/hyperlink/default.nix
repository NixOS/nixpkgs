{ stdenv, buildPythonPackage, fetchurl, pytest }:

buildPythonPackage rec {
  pname = "hyperlink";
  version = "17.3.0";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/h/hyperlink/${name}.tar.gz";
    sha256 = "06mgnxwjzx8hv34bifc7jvgxz21ixhk5s6xy2kd84hdrlbfvpbfx";
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
