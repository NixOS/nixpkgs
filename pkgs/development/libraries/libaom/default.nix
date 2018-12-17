{ stdenv, fetchgit, yasm, perl, cmake, pkgconfig, python3Packages, writeText }:

stdenv.mkDerivation rec {
  name = "libaom-${version}";
  version = "1.0.0";

  src = fetchgit {
    url = "https://aomedia.googlesource.com/aom";
    rev	= "v${version}";
    sha256 = "07h2vhdiq7c3fqaz44rl4vja3dgryi6n7kwbwbj1rh485ski4j82";
  };

  buildInputs = [ perl yasm ];
  nativeBuildInputs = [ cmake pkgconfig python3Packages.python ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  # * libaom tries to detect what version it is
  #   * I couldn't get it to grab this from git info,
  #     (which needs at least leaveDotGit=true)
  #   * it uses a perl script to parse from CHANGELOG,
  #     but 1.0.0 doesn't contain an entry for itself :(
  # * Upstream patch that adds the entry also nukes all of
  #   the versions before a project change (open-sourcing?)
  #   and as a result is 34K which is way too big just to fix this!
  #   * A stable URL to fetch this from works, but...
  # * Upon inspection the resulting CHANGELOG is shorter
  #   than this comment, so while yes this is a bit gross
  #   adding these 4 lines here does the job without
  #   a huge patch in spirit of preferring upstream's fix
  #   instead of `sed -i 's/v0\.1\.0/v1.0.0/g' aom.pc` or so.
  postPatch = let actual_changelog = writeText "CHANGELOG" ''
    2018-06-28 v1.0.0
      AOMedia Codec Workgroup Approved version 1.0

    2016-04-07 v0.1.0 "AOMedia Codec 1"
      This release is the first Alliance for Open Media codec.
  ''; in ''
   cp ${actual_changelog} CHANGELOG
  '';

  meta = with stdenv.lib; {
    description = "AV1 Bitstream and Decoding Library";
    homepage    = https://aomedia.org/av1-features/get-started/;
    maintainers = with maintainers; [ kiloreux ];
    platforms   = platforms.all;
    license = licenses.bsd2;
  };
}
