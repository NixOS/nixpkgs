{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "0.0.7.3";
  pname = "pylightning";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a07b62b27e01baaf51165e2dfb8b7d1d47f61aef8304a9da3ca5081608a32c0";
  };

  meta = with stdenv.lib; {
    description = "A Python client library for clightning";
    homepage = https://github.com/ElementsProject/lightning;
    license = licenses.mit;
    maintainers = with maintainers; [ jb55 ];
  };

}
