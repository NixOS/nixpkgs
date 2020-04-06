{ stdenv, fetchFromGitHub, fetchpatch, libX11, libXt, withGraphics ? true }:

stdenv.mkDerivation rec {
  pname = "icon-lang";
  version = "9.5.1";
  src = fetchFromGitHub {
    owner = "gtownsend";
    repo = "icon";
    rev = "rel${builtins.replaceStrings ["."] [""] version}";
    sha256 = "1gkvj678ldlr1m5kjhx6zpmq11nls8kxa7pyy64whgakfzrypynw";
  };

  buildInputs = stdenv.lib.optionals withGraphics [ libX11 libXt ];

  patches = [
    # Patch on git master, likely won't be necessary in future release
    (fetchpatch {
      url = "https://github.com/gtownsend/icon/commit/bfc4a6004d0d3984c8066289b8d8e563640c4ddd.patch";
      sha256 = "1pqapjghk10rb73a1mfflki2wipjy4kvnravhmrilkqzb9hd6v8m";
      excludes = [
        "doc/relnotes.htm"
        "src/h/version.h"
      ];
    })
  ];

  configurePhase =
    let
      _name = if stdenv.isDarwin then "macintosh" else "linux";
    in
    ''
      make ${stdenv.lib.optionalString withGraphics "X-"}Configure name=${_name}
    '';

  installPhase = ''
    make Install dest=$out
  '';

  meta = with stdenv.lib; {
    description = ''A very high level general-purpose programming language'';
    maintainers = with maintainers; [ vrthra yurrriq ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.publicDomain;
    homepage = https://www.cs.arizona.edu/icon/;
  };
}
