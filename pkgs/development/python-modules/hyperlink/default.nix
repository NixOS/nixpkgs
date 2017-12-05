{ stdenv, buildPythonPackage, fetchurl, pytest }:
buildPythonPackage rec {
  name = "hyperlink-${version}";
  version = "17.3.0";

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
