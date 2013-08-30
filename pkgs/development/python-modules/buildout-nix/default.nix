{ fetchurl, stdenv, buildPythonPackage }:

buildPythonPackage {
  name = "zc.buildout-nix-2.2.0";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/z/zc.buildout/zc.buildout-2.2.0.tar.gz";
    md5 = "771dd9807da7d5ef5bb998991c5fdae1";
  };

  patches = [ ./nix.patch ];

  postInstall = "mv $out/bin/buildout{,-nix}";

  meta = {
    homepage = "http://www.buildout.org";
    description = "A software build and configuration system";
    license = stdenv.lib.licenses.zpt21;
    maintainers = [ stdenv.lib.maintainers.goibhniu ];
  };
}
