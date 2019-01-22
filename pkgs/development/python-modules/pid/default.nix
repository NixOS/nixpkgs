{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "pid";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "636cb4743a6e6fb1d89efcfd772e6deb5a058590f3531703595d776507098d7b";
  };

  buildInputs = [ nose ];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Pidfile featuring stale detection and file-locking";
    homepage = https://github.com/trbs/pid/;
    license = licenses.asl20;
  };

}
