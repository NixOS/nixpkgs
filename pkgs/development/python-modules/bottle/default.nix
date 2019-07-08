{ stdenv, buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  pname = "bottle";
  version = "0.12.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c310da61e7df2b6ac257d8a90811899ccb3a9743e77e947101072a2e3186726";
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
