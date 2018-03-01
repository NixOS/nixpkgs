{ stdenv, fetchPypi, buildPythonPackage
, urllib3, idna, chardet, certifi
, pytest }:

buildPythonPackage rec {
  pname = "requests";
  version = "2.18.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zi3v9nsmv9j27d0c0m1dvqyvaxz53g8m0aa1h3qanxs4irkwi4w";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pytest ];
  propagatedBuildInputs = [ urllib3 idna chardet certifi ];
  # sadly, tests require networking
  doCheck = false;

  meta = with stdenv.lib; {
    description = "An Apache2 licensed HTTP library, written in Python, for human beings";
    homepage = http://docs.python-requests.org/en/latest/;
    license = licenses.asl20;
  };
}
