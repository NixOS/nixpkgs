{ stdenv, buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  pname = "bottle";
  version = "0.12.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cd787lzggs933qfav6xicx5c78dz6npwgg3xc4rhah44nbqz5d1";
  };

  propagatedBuildInputs = [ setuptools ];

  meta = with stdenv.lib; {
    homepage = http://bottlepy.org;
    description = "A fast and simple micro-framework for small web-applications";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ koral ];
  };
}
