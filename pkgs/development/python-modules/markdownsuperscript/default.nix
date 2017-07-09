{ stdenv, buildPythonPackage, fetchPypi, markdown }:

buildPythonPackage rec {
  pname = "MarkdownSuperscript";
  version = "2.0.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dsx21h9hkx098d5azpw81dcz23rrgzrwlymwv7jri348q26p748";
  };

  propagatedBuildInputs = [ markdown ];

  doCheck = false; # See https://github.com/NixOS/nixpkgs/pull/26985

  meta = {
    description = "An extension to the Python Markdown package enabling superscript text";
    homepage = https://github.com/jambonrose/markdown_superscript_extension;
    license = stdenv.lib.licenses.bsd2;
  };
}
