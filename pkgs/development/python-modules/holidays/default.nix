{ stdenv, buildPythonPackage, fetchPypi, six, dateutil, convertdate, korean-lunar-calendar }:

buildPythonPackage rec {
  pname = "holidays";
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a91324fcaa4c72a0fe9a13601436f65ee33b2ef033686f4e2228d58a7631970";
  };

  propagatedBuildInputs = [ six dateutil convertdate korean-lunar-calendar ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/dr-prodigy/python-holidays";
    description = "Generate and work with holidays in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
