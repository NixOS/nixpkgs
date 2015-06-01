{ stdenv, fetchFromGitHub, cmake, python }:

stdenv.mkDerivation rec {
  name = "jsoncpp-${version}";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "open-source-parsers";
    repo = "jsoncpp";
    rev = version;
    sha256 = "0p92i0hx2k3g8mwrcy339b56bfq8qgpb65id8xllkgd2ns4wi9zi";
  };

  /* During darwin bootstrap, we have a cp that doesn't understand the
   * --reflink=auto flag, which is used in the default unpackPhase for dirs
   */
  unpackPhase = ''
    cp -a ${src} ${src.name}
    chmod -R +w ${src.name}
    export sourceRoot=${src.name}
  '';

  nativeBuildInputs = [ cmake python ];

  cmakeFlags = [
    "-DJSONCPP_WITH_CMAKE_PACKAGE=1"
  ];

  postInstall = "rm $out/lib/*.a";

  meta = {
    inherit version;
    homepage = https://github.com/open-source-parsers/jsoncpp;
    description = "A simple API to manipulate JSON data in C++";
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
    license = stdenv.lib.licenses.mit;
    branch = "1.6";
  };
}
