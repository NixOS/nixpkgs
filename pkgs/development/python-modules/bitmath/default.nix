{ stdenv, buildPythonPackage, fetchPypi, isPy3k, progressbar231, progressbar33, mock }:

buildPythonPackage rec {
  pname = "bitmath";
  version = "1.3.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k8d1wmxqjc8cqzaixpxf45k6dl1kqhblr0g4wyjl0qa18q8wasd";
  };

  checkInputs = [ (if isPy3k then progressbar33 else progressbar231) mock ];

  meta = with stdenv.lib; {
    description = "Module for representing and manipulating file sizes with different prefix";
    homepage = https://github.com/tbielawa/bitmath;
    license = licenses.mit;
    maintainers = with maintainers; [ twey ];
  };
}
