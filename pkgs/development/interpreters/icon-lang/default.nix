{ stdenv, fetchFromGitHub
, libX11, libXt
, withGraphics ? true
}:

stdenv.mkDerivation rec {
  pname = "icon-lang";
  version = "9.5.20i";

  src = fetchFromGitHub {
    owner = "gtownsend";
    repo = "icon";
    rev = "v${version}";
    sha256 = "0072b3jk8mc94w818z8bklhjdf9rf0d9a7lkvw40pz3niy7zv84s";
  };

  buildInputs = stdenv.lib.optionals withGraphics [ libX11 libXt ];

  configurePhase = let
    target = if withGraphics then "X-Configure" else "Configure";
    platform = if stdenv.isLinux  then "linux"
          else if stdenv.isDarwin then "macintosh"
          else if stdenv.isBSD    then "bsd"
          else if stdenv.isCygwin then "cygwin"
          else if stdenv.isSunOS  then "solaris"
          else throw "unsupported system";
  in "make ${target} name=${platform}";

  installPhase = "make Install dest=$out";

  meta = with stdenv.lib; {
    description = ''A very high level general-purpose programming language'';
    maintainers = with maintainers; [ vrthra yurrriq ];
    platforms = with platforms; linux ++ darwin ++ freebsd ++ netbsd ++ openbsd ++ cygwin ++ illumos;
    license = licenses.publicDomain;
    homepage = "https://www.cs.arizona.edu/icon/";
  };
}
