{ stdenv
, fetchFromGitLab
, fetchpatch
, autoreconfHook
, pkgconfig
, pcsclite
, PCSC
}:

stdenv.mkDerivation rec {
  pname = "aribb25";
  version = "0.2.7";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = pname;
    # rev = version; FIXME: uncomment in next release
    rev = "c14938692b313b5ba953543fd94fd1cad0eeef18"; # 0.2.7 with build fixes
    sha256 = "1kb9crfqib0npiyjk4zb63zqlzbhqm35nz8nafsvdjd71qbd2amp";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = if stdenv.isDarwin then [ PCSC ] else [ pcsclite ];

  patches = let
    url = pr: "https://code.videolan.org/videolan/${pname}/-/merge_requests/${pr}.patch";
  in [
    (fetchpatch {
      name = "make-cli-pipes-work.patch";
      url = url "3";
      sha256 = "1sx4zb8c3hxbq81ykxijdl11bh1imw206qzx9319z35pyi7qdxjp";
    })
  ];

  meta = with stdenv.lib; {
    homepage = "https://code.videolan.org/videolan/aribb25";
    description = "Sample implementation of the ARIB STD-B25 standard";
    platforms = platforms.all;
    license = licenses.isc;
    maintainers = with maintainers; [ midchildan ];
  };
}
