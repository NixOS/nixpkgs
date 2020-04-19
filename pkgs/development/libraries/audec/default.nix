{ stdenv, fetchgit, libsndfile, libsamplerate, meson, ninja, pkg-config }:

stdenv.mkDerivation rec {
  pname = "audec";
  version = "0.2";

  src = fetchgit {
    url = "https://git.zrythm.org/git/libaudec";
    rev = "v${version}";
    sha256 = "0lfydvs92b0hr72z71ci3yi356rjzi162pgms8dphgg18bz8dazv";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [
    libsndfile
    libsamplerate
  ];

  meta = with stdenv.lib; {
    description = "Library for reading and resampling audio files";
    homepage = "https://git.zrythm.org/cgit/libaudec";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
