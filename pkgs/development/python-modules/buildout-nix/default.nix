{ fetchurl, stdenv, buildPythonPackage }:

buildPythonPackage {
  name = "zc.buildout-nix-2.5.0";

  src = fetchurl {
    url = "mirror://pypi/z/zc.buildout/zc.buildout-2.5.0.tar.gz";
    sha256 = "721bd2231a9f01f2d5c14f3adccb3385f85b093ee05b18d15d0ff2b9f1f1bd02";
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
