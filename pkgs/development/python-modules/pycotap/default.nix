{ stdenv, fetchPypi, python }:

python.pkgs.buildPythonPackage rec {
  pname   = "pycotap";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f938ecd4931ccd19d9598fb633d5eabb7938f08b84717315e52526aa6277c9ec";
  };

  meta = with stdenv.lib; {
    homepage = "https://el-tramo.be/pycotap";
    description = "A tiny test runner that outputs TAP results to standard output";
    license = licenses.mit;
    maintainers = with maintainers; [ genesis ];
  };

}
