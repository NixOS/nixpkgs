{ stdenv, fetchFromGitHub
, autoreconfHook
, guile
, libffi
, libssh
, which
, pkgconfig
, texinfo
 }:

let
  name = "guile-ssh-${version}";
  version = "0.11.3";
in stdenv.mkDerivation {
  inherit name;

  src = fetchFromGitHub {
    owner = "artyom-poptsov";
    repo = "guile-ssh";
    rev = "v${version}";
    sha256 = "03bv3hwp2s8f0bqgfjaan9jx4dyab0abv27n2zn2g0izlidv0vl6";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    which
    texinfo
  ];

  buildInputs = [
    guile
    libffi
    libssh
  ];

  preConfigure = ''
    configureFlags="$configureFlags --with-guilesitedir=$out/share/guile/site"
  '';

  meta = with stdenv.lib; {
    description = "a library that provides access to the SSH protocol for GNU Guile programs";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zimbatm ];
    platforms = platforms.gnu ++ platforms.linux;
  };
}
