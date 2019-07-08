{ fetchPypi, stdenv, buildPythonPackage }:

buildPythonPackage rec {
  pname = "zc.buildout";
  version = "2.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d14d07226963a517295dfad5879d2799e2e3b65b2c61c71b53cb80f5ab11484";
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
