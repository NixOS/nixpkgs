{ fetchPypi, stdenv, buildPythonPackage }:

buildPythonPackage rec {
  pname = "zc.buildout";
  version = "2.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff5d7e8a1361da8dfe1025d35ef6ce55e929dd8518d2a811a1cf2c948950a043";
  };

  patches = [ ./nix.patch ];

  postInstall = "mv $out/bin/buildout{,-nix}";

  meta = {
    homepage = http://www.buildout.org;
    description = "A software build and configuration system";
    license = stdenv.lib.licenses.zpl21;
    maintainers = [ stdenv.lib.maintainers.goibhniu ];
  };
}
