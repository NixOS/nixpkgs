{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, boto, redis, setuptools, simplejson }:

buildPythonPackage rec {
  pname = "docker-registry-core";
  version = "2.0.3";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q036rr0b5734szkj883hkb2kjhgcc5pm3dz4yz8vcim3x7q0zil";
  };

  DEPS = "loose";

  doCheck = false;
  propagatedBuildInputs = [ boto redis setuptools simplejson ];

  patchPhase = "> requirements/main.txt";

  meta = with stdenv.lib; {
    description = "Docker registry core package";
    homepage = https://github.com/docker/docker-registry;
    license = licenses.asl20;
  };
}
