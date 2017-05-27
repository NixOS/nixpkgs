{ stdenv, buildPythonPackage, fetchurl,
  m2r, setuptools_scm, six, attrs }:
buildPythonPackage rec {
  version = "0.5.0";
  pname = "Automat";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/A/Automat/${name}.tar.gz";
    sha256 = "1hnpknkqnc2m900kkzrzx9l6g5dy5dassrdj9pn34x1pcdkyr2a8";
  };

  buildInputs = [ m2r setuptools_scm ];
  propagatedBuildInputs = [ six attrs ];

  # Some tests require twisetd, but twisted requires Automat to build.
  # this creates a circular dependency.
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/glyph/Automat;
    description = "Self-service finite-state machines for the programmer on the go";
    license = licenses.mit;
    maintainers = [ ];
  };
}
