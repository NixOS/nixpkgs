{ stdenv, buildPythonPackage, fetchurl }:

buildPythonPackage rec {
  name = "markdown2-${version}";
  version = "2.3.1";

  src = fetchurl {
    url = "mirror://pypi/m/markdown2/${name}.zip";
    sha256 = "03nqcx79r9lr5gp2zpqa1n54hnxqczdq27f2j3aazr3r9rsxsqs4";
  };

  meta = with stdenv.lib; {
    description = "A fast and complete Python implementation of Markdown";
    homepage =  https://github.com/trentm/python-markdown2;
    license = licenses.mit;
    maintainers = with maintainers; [ hbunke ];
  };
}
