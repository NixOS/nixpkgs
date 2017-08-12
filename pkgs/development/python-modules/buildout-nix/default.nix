{ fetchurl, stdenv, buildPythonPackage }:

buildPythonPackage {
  name = "zc.buildout-nix-2.5.3";

  src = fetchurl {
    url = "https://pypi.python.org/packages/e4/7b/63863f09bec5f5d7b9474209a6d4d3fc1e0bca02ecfb4c17f0cdd7b554b6/zc.buildout-2.5.3.tar.gz";
    sha256 = "3e5f3afcc64416604c5efc554c2fa0901b60657e012a710c320e2eb510efcfb9";
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
