{ lib, fetchurl, buildDunePackage, fmt, logs, stdlib-shims }:

buildDunePackage rec {
  pname = "index";
  version = "1.2.0";

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/index/releases/download/${version}/index-${version}.tbz";
    sha256 = "0d44s1d2mpxvpg0zh57c928wf1w1wd33l1fw5r62al5zmi710ff6";
  };

  buildInputs = [ stdlib-shims ];
  propagatedBuildInputs = [ fmt logs ];

  meta = {
    homepage = "https://github.com/mirage/index";
    description = "A platform-agnostic multi-level index";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
