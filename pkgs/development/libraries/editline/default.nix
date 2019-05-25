{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "editline-${version}";
  version = "1.16.0";
  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "editline";
    rev = version;
    sha256 = "0a751dp34mk9hwv59ss447csknpm5i5cgd607m3fqf24rszyhbf2";
  };

  patches = [
    # will be in 1.17.0
    (fetchpatch {
      name = "redisplay-clear-screen.patch";
      url = "https://github.com/troglobit/editline/commit/a4b67d226829a55bc8501f36708d5e104a52fbe4.patch";
      sha256 = "0dbgdqxa4x9wgr9kx89ql74np4qq6fzdbph9j9c65ns3gnaanjkw";
    })
    # PR24
    (fetchpatch {
      name = "fix-narrow-term-crash.patch";
      url = https://github.com/troglobit/editline/pull/24/commits/8660aef4b795fbd46a86dca804f067a81757c5df.patch;
      sha256 = "0pcz1f141qv78xbq09yh0zfcjiqyavr66snz1hvxzvi8x0vixc4i";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  outputs = [ "out" "dev" "man" "doc" ];

  meta = with stdenv.lib; {
    homepage = http://troglobit.com/editline.html;
    description = "A readline() replacement for UNIX without termcap (ncurses)";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
