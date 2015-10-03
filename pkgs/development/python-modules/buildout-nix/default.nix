{ fetchurl, stdenv, buildPythonPackage }:

buildPythonPackage {
  name = "zc.buildout-nix-2.4.3";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/z/zc.buildout/zc.buildout-2.4.3.tar.gz";
    sha256 = "db877d791e058a6207ac716e1017296e6862e4f1b5388dd145702eb19d902580";
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
