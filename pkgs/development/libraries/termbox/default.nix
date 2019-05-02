{ stdenv, fetchFromGitHub, python3, wafHook, fetchpatch }:

stdenv.mkDerivation rec {
  name = "termbox-${version}";
  version = "1.1.2";
  src = fetchFromGitHub {
    owner = "nsf";
    repo = "termbox";
    rev = "v${version}";
    sha256 = "08yqxzb8fny8806p7x8a6f3phhlbfqdd7dhkv25calswj7w1ssvs";
  };

  # patch which updates the `waf` version used to build
  # to make the package buildable on Python 3.7
  patches = [
    (fetchpatch {
      url = https://github.com/nsf/termbox/commit/6fe63ac3ad63dc2c3ac45b770541cc8b7a1d2db7.patch;
      sha256 = "1s5747v51sdwvpsg6k9y1j60yn9f63qnylkgy8zrsifjzzd5fzl6";
    })
  ];

  nativeBuildInputs = [ python3 wafHook ];

  meta = with stdenv.lib; {
    description = "Library for writing text-based user interfaces";
    license = licenses.mit;
    homepage = "https://github.com/nsf/termbox#readme";
    downloadPage = "https://github.com/nsf/termbox/releases";
    maintainers = with maintainers; [ fgaz ];
  };
}
