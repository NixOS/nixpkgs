{ stdenv, buildPythonPackage, fetchurl }:

buildPythonPackage rec {
  pname = "markdown2";
  version = "2.3.5";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/m/markdown2/${name}.zip";
    sha256 = "8bb9a24eb2aa02f1427aabe46483f0f0215ab18c8a345315ae8e2ee3c3a09c03";
  };

  meta = with stdenv.lib; {
    description = "A fast and complete Python implementation of Markdown";
    homepage =  https://github.com/trentm/python-markdown2;
    license = licenses.mit;
    maintainers = with maintainers; [ hbunke ];
  };
}
