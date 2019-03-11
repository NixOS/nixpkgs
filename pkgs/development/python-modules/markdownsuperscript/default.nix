{ stdenv, buildPythonPackage, fetchPypi, markdown }:

buildPythonPackage rec {
  pname = "MarkdownSuperscript";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c255b5959c1f5dd364ae80762bd0a568a0fcc9fd4e4a3d7e7b192e88adf8900";
  };

  propagatedBuildInputs = [ markdown ];

  doCheck = false; # See https://github.com/NixOS/nixpkgs/pull/26985

  meta = {
    description = "An extension to the Python Markdown package enabling superscript text";
    homepage = https://github.com/jambonrose/markdown_superscript_extension;
    license = stdenv.lib.licenses.bsd2;
  };
}
