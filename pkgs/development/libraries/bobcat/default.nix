{ stdenv, fetchFromGitHub, icmake, libmilter, libX11, openssl, readline
, utillinux, yodl }:

stdenv.mkDerivation rec {
  name = "bobcat-${version}";
  version = "4.01.04";

  src = fetchFromGitHub {
    sha256 = "1qnyssvjvwc7ann5rw8spcfrfkxyh1lv3k12bq19d8db67znk4ms";
    rev = version;
    repo = "bobcat";
    owner = "fbb-git";
  };

  buildInputs = [ libmilter libX11 openssl readline utillinux ];
  nativeBuildInputs = [ icmake yodl ];

  sourceRoot = "bobcat-${version}-src/bobcat";

  postPatch = ''
    substituteInPlace INSTALL.im --replace /usr $out
    patchShebangs .
  '';

  buildPhase = ''
    ./build libraries all
    ./build man
  '';

  installPhase = ''
    ./build install x
  '';

  meta = with stdenv.lib; {
    description = "Brokken's Own Base Classes And Templates";
    homepage = https://fbb-git.github.io/bobcat/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
