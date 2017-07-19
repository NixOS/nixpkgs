{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "0.4";
  pname = "python-editor";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gykxn16anmsbcrwhx3rrhwjif95mmwvq9gjcrr9bbzkdc8sf8a4";
  };

  meta = with stdenv.lib; {
    description = "A library that provides the `editor` module for programmatically";
    homepage = "https://github.com/fmoo/python-editor";
  };
}
