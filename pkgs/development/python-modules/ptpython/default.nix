{ stdenv, buildPythonPackage, fetchPypi, wcwidth, six, prompt_toolkit, docopt
, jedi, pygments }:

buildPythonPackage rec {
  pname = "ptpython";
  version = "0.41";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hcaaadkp5n37hxggraynifa33wx1akklzvf6y4rvgjxbjl2g2x7";
  };

  propagatedBuildInputs = [ wcwidth six prompt_toolkit docopt jedi pygments ];

  # no tests to run
  doCheck = false;

  meta = with stdenv.lib; {
    description = "An advanced Python REPL";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mlieberman85 ];
    platforms = platforms.all;
  };
}
