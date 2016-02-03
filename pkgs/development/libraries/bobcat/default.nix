{ stdenv, fetchFromGitHub, icmake, libmilter, libX11, openssl, readline
, utillinux, yodl }:

stdenv.mkDerivation rec {
  name = "bobcat-${version}";
  version = "4.00.00";

  src = fetchFromGitHub {
    sha256 = "0wdb25sgw7i3jk3lbja6b4ipqfg1sncam6adg2bn8l5fcinrpwgs";
    rev = version;
    repo = "bobcat";
    owner = "fbb-git";
  };

  buildInputs = [ libmilter libX11 openssl readline utillinux ];
  nativeBuildInputs = [ icmake yodl ];

  sourceRoot = "bobcat-${version}-src/bobcat";

  postPatch = ''
    substituteInPlace INSTALL.im --replace /usr $out
    patchShebangs ./build
  '';

  buildPhase = ''
    ./build libraries all
    ./build man
  '';

  installPhase = ''
    ./build install
  '';

  meta = with stdenv.lib; {
    description = "Brokken's Own Base Classes And Templates";
    homepage = https://fbb-git.github.io/bobcat/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
