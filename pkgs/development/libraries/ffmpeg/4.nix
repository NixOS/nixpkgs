{ callPackage
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, stdenv, lib
, fetchpatch
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "4.4";
  branch = "4.4";
  sha256 = "03kxc29y8190k4y8s8qdpsghlbpmchv1m8iqygq2qn0vfm4ka2a2";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];

  patches = [
    # Fix incorrect segment length in HLS child playlist with fmp4 segment format
    # FIXME remove in version 4.5
    # https://trac.ffmpeg.org/ticket/9193
    # https://trac.ffmpeg.org/ticket/9205
    (fetchpatch {
      name = "ffmpeg_fix_incorrect_segment_length_in_hls.patch";
      url = "https://git.videolan.org/?p=ffmpeg.git;a=commitdiff_plain;h=59032494e81a1a65c0b960aaae7ec4c2cc9db35a";
      sha256 = "03zz1lw51kkc3g3vh47xa5hfiz3g3g1rbrll3kcnslvwylmrqmy3";
    })
  ] ++ lib.optionals stdenv.isDarwin [
    # Work around https://trac.ffmpeg.org/ticket/9242
    ./v2-0001-avcodec-videotoolboxenc-define-TARGET_CPU_ARM64-t.patch
  ];
} // args)
