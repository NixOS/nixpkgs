{ stdenv, buildPythonPackage, fetchPypi, prompt_toolkit, appdirs, docopt, jedi
, pygments, isPy3k }:

buildPythonPackage rec {
  pname = "ptpython";
  version = "3.0.3";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ac4e4047ca3a03133702a353a93cf56ca1ec1162bc7ecaff087a91c03e3827b";
  };

  propagatedBuildInputs = [ appdirs prompt_toolkit docopt jedi pygments ];

  # no tests to run
  doCheck = false;

  meta = with stdenv.lib; {
    description = "An advanced Python REPL";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mlieberman85 ];
    platforms = platforms.all;
  };
}
