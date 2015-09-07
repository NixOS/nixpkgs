{ fetchurl, stdenv, buildPythonPackage }:

buildPythonPackage {
  name = "zc.buildout-nix-2.4.0";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/z/zc.buildout/zc.buildout-2.4.0.tar.gz";
    md5 = "b8323b1ad285544de0c3dc14ee76ddd3";
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
