{ stdenv, fetchgit, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "breakpad-2017-11-13";
  
  src = fetchgit {
    url = "https://chromium.googlesource.com/breakpad/breakpad";
    rev = "70914b2d380d893364ad0110b8af18ba1ed5aaa3";
    sha256 = "1k6wgggs6i6mzf0la5a0gqxyazl604jq1r4zikqk5rqwsn8srjk1";
  };

  linux-syscall-support = fetchgit {
    url = "https://chromium.googlesource.com/linux-syscall-support";
    rev = "e6527b0cd469e3ff5764785dadcb39bf7d787154";
    sha256 = "09d1zw86jnbpqqxcfw6k4d37lv351v6haljxcsx20334ay4l7lml";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];
  preConfigure = "ln -s ${linux-syscall-support} src/third_party/lss";

  meta = with stdenv.lib; {
    platforms = platforms.unix;
  };
}
