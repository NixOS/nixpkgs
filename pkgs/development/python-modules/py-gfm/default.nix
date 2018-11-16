{ lib
, fetchPypi
, buildPythonPackage
, markdown
}:

buildPythonPackage rec {
  pname = "py-gfm";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef6750c579d26651cfd23968258b604228fd71b2a4e1f71dea3bea289e01377e";
  };

  buildInputs = [ markdown ];

  meta = with lib; {
    homepage = https://github.com/zopieux/py-gfm;
    description = "GitHub-Flavored Markdown as an extension to the Python Markdown library.";
    longDescription = ''
      This is an implementation of GitHub-Flavored Markdown written as an
      extension to the Python Markdown library. It aims for maximal
      compatibility with GitHub's rendering.
    '';
    license = licenses.bsd3;
    maintainers = [ maintainers.bsima ];
  };
}
