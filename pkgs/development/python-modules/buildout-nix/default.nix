{ fetchurl, stdenv, buildPythonPackage }:

buildPythonPackage rec {
  pname = "zc.buildout";
  version = "2.11.2";
  name = "${pname}-nix-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${pname}-${version}.tar.gz";
    sha256 = "e304f3604a4235e896e94ea79230cfb9c0bc54569f04d5c6c4b49cc9dc4fdbf6";
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
