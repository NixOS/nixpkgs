{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "filelock";
  version = "3.0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rjv7g85smh6hrq6n9h721kh83qjv8mfp0ksdnbqbbsd82xw246n";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/benediktschmitt/py-filelock;
    description = "A platform independent file lock for Python";
    license = licenses.unlicense;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
