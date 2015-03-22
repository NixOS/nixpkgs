{ stdenv, fetchurl, cmake, python }:

let
  basename = "jsoncpp";
  version = "1.6.0";
in
stdenv.mkDerivation rec {
  name = "${basename}-${version}";
  src = fetchurl {
    url = "https://github.com/open-source-parsers/${basename}/archive/${version}.tar.gz";
    sha256 = "0ff1niks3y41gr6z13q9m391na70abqyi9rj4z3y2fz69cwm6sgz";
  };

  nativeBuildInputs =
    [
      # cmake can be built with the system jsoncpp, or its own bundled version.
      # Obviously we cannot build it against the system jsoncpp that doesn't yet exist, so
      # we make a bootstrapping build with the bundled version.
      (cmake.override { jsoncpp = null; })
      python
    ];

  meta = {
    inherit version;
    homepage = https://github.com/open-source-parsers/jsoncpp;
    description = "A simple API to manipulate JSON data in C++";
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
    license = with stdenv.lib.licenses; [ mit ];
    branch = "1.6";
  };
}
