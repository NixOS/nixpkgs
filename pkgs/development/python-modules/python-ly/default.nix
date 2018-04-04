{ buildPythonPackage, fetchPypi, stdenv }:

buildPythonPackage rec {
  pname = "python-ly";
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x98dv7p8mg26p4816yy8hz4f34zf6hpnnfmr56msgh9jnsm2qfl";
  };

  # tests not shipped on `pypi` and
  # seem to be broken ATM: https://github.com/wbsoft/python-ly/issues/70
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tool and library for manipulating LilyPond files";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ma27 ];
  };
}
