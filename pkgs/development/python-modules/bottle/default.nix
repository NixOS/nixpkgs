{ stdenv, buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  pname = "bottle";
  version = "0.12.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e9eaa412a60cc3d42ceb42f58d15864d9ed1b92e9d630b8130c871c5bb16107c";
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
