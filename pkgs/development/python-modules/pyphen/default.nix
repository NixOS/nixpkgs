{ lib
, fetchurl
, buildPythonPackage
}:

let
  pname = "Pyphen";
  version = "0.9.4";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "abfa9a0ab055341f6e250c1a6bef395c3a06f0e4cba216eeef37f617b32c0bd7";
  };

  # No tests included
  doCheck = false;

  meta = {
    description = "Pure Python module to hyphenate text";
    homepage = https://github.com/Kozea/Pyphen;
    license = with lib.licenses; [ gpl2 lgpl21 mpl11 ];
  };
}
