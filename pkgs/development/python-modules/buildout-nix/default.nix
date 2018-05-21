{ fetchurl, stdenv, buildPythonPackage }:

buildPythonPackage rec {
  pname = "zc.buildout";
  version = "2.11.3";
  name = "${pname}-nix-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${pname}-${version}.tar.gz";
    sha256 = "f7fde2cde7b937f67e52a3e94b76f9294b73c1e9bb698430e96778f3f735544c";
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
