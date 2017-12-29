{ stdenv, buildPythonPackage, fetchurl }:

buildPythonPackage rec {
  pname = "markdown2";
  version = "2.3.4";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/m/markdown2/${name}.zip";
    sha256 = "264731e7625402227ff6fb01f2d814882da7705432659a18a419c508e8bfccb1";
  };

  meta = with stdenv.lib; {
    description = "A fast and complete Python implementation of Markdown";
    homepage =  https://github.com/trentm/python-markdown2;
    license = licenses.mit;
    maintainers = with maintainers; [ hbunke ];
  };
}
