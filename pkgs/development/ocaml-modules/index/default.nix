{ lib, fetchurl, buildDunePackage, fmt, logs, mtime, stdlib-shims }:

buildDunePackage rec {
  pname = "index";
  version = "1.2.1";

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/index/releases/download/${version}/index-${version}.tbz";
    sha256 = "1a9b6rsazrjy07syxl9ix5002i95mlvx5vk7nl2x9cs6s0zw906d";
  };

  buildInputs = [ stdlib-shims ];
  propagatedBuildInputs = [ fmt logs mtime ];

  meta = {
    homepage = "https://github.com/mirage/index";
    description = "A platform-agnostic multi-level index";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
