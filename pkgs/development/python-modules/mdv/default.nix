{ stdenv, buildPythonPackage,
  fetchPypi, markdown, pygments, pyyaml, docopt
}:

buildPythonPackage rec {
  pname = "mdv";
  version = "1.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x4d1gyvmdqh2zpdc415ak10d4yfli04pw4mxwfv2jnjk94d1y0k";
  };

  propagatedBuildInputs = [ markdown pygments pyyaml docopt ];

  meta = with stdenv.lib; {
    homepage = https://github.com/axiros/terminal_markdown_viewer;
    description = "Terminal Markdown Viewer";
    license = licenses.bsd;
    maintainers = with maintainers; [ synthetica ];
  };
}
