{ lib, fetchurl, buildDunePackage, cppo, easy-format, biniou }:

buildDunePackage rec {
  pname = "yojson";
  version = "1.7.0";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/ocaml-community/yojson/releases/download/${version}/yojson-${version}.tbz";
    sha256 = "1iich6323npvvs8r50lkr4pxxqm9mf6w67cnid7jg1j1g5gwcvv5";
  };

  nativeBuildInputs = [ cppo ];
  propagatedBuildInputs = [ easy-format biniou ];

  meta = with lib; {
    description = "An optimized parsing and printing library for the JSON format";
    homepage = "https://github.com/ocaml-community/${pname}";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    mainProgram = "ydump";
  };
}
