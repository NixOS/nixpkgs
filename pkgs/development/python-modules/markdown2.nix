{ stdenv, buildPythonPackage, fetchurl }:

buildPythonPackage rec {
  pname = "markdown2";
  version = "2.3.1";
  name = "${pname}-${version}";

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
