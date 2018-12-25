{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "munkres";
  version = "1.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c78f803b9b776bfb20a25c9c7bb44adbf0f9202c2024d51aa5969d21e560208d";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://bmc.github.com/munkres/;
    description = "Munkres algorithm for the Assignment Problem";
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };

}
