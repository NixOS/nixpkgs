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
    (fetchpatch {
      name = "CVE-2021-33815.patch";
      url = "https://github.com/FFmpeg/FFmpeg/commit/26d3c81bc5ef2f8c3f09d45eaeacfb4b1139a777.patch";
      sha256 = "0l8dqga5845f7d3wdbvd05i23saldq4pm2cyfdgszbr0c18sxagf";
    })
    (fetchpatch {
      name = "CVE-2021-38114.patch";
      url = "https://github.com/FFmpeg/FFmpeg/commit/7150f9575671f898382c370acae35f9087a30ba1.patch";
      sha256 = "0gwkc7v1wsh4j0am2nnskhsca1b5aqzhcfd41sd9mh2swsdyf27i";
    })
    (fetchpatch {
      name = "CVE-2021-38171.patch";
      url = "https://github.com/FFmpeg/FFmpeg/commit/9ffa49496d1aae4cbbb387aac28a9e061a6ab0a6.patch";
      sha256 = "0b8hsb45izw7w1vb2b94k9f6kvn2shxrap5ip1krdxg6hs7an0x8";
    })
    (fetchpatch {
      name = "CVE-2021-38291.patch";
      url = "https://github.com/FFmpeg/FFmpeg/commit/e01d306c647b5827102260b885faa223b646d2d1.patch";
      sha256 = "0p2p8gcnb5j469xa3czfssm09w3jk08kz8rnl8wi2l9aj9l08my9";
    })
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
