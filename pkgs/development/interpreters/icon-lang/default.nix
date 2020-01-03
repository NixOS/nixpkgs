{ stdenv, fetchFromGitHub, libX11, libXt , withGraphics ? true }:

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
