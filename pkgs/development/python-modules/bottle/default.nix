{ stdenv, buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  pname = "bottle";
  version = "0.12.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "39b751aee0b167be8dffb63ca81b735bbf1dd0905b3bc42761efedee8f123355";
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
