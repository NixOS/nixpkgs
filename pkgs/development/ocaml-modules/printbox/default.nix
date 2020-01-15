{ stdenv, fetchFromGitHub, buildDunePackage, mdx }:

buildDunePackage rec {
  pname = "printbox";
  version = "0.2";

  minimumOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = pname;
    rev = version;
    sha256 = "16nwwpp13hzlcm9xqfxc558afm3i5s802dkj69l9s2vp04lgms5n";
  };

  checkInputs = [ mdx ];

  doCheck = true;

  meta = {
    homepage = https://github.com/c-cube/printbox/;
    description = "Allows to print nested boxes, lists, arrays, tables in several formats";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
