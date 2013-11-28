{ fetchurl, stdenv, buildPythonPackage }:

buildPythonPackage {
  name = "zc.buildout-nix-2.2.1";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/z/zc.buildout/zc.buildout-2.2.1.tar.gz";
    md5 = "476a06eed08506925c700109119b6e41";
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
