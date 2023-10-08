{ stdenv, lib, fetchFromGitHub, fetchpatch
, autoconf, automake, libtool, openssl, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libetpan";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "dinhviethoa";
    repo = "libetpan";
    rev = version;
    hash = "sha256-lukeWURNsRPTuFk2q2XVnwkKz5Y+PRiPba5GPQCw6jw=";
  };

  outputs = [ "out" "dev" ];

  patches = [
    # The following patches are security and/or reliability fixes.
    # They all must be removed for the next version bump.

    # Fix potential null pointer deference
    # https://github.com/dinhvh/libetpan/pull/348
    (fetchpatch {
      name = "pr-348-null-pointer-deference.patch";
      url = "https://github.com/dinhvh/libetpan/commit/720e92e5752e562723a9730f8e604cb78f3a9163.patch";
      hash = "sha256-/bA/ekeMhLE3OyREHIanlrb+uuSxwur+ZloeaX9AyyM=";
    })

    # Fix potential null pointer deference
    # https://github.com/dinhvh/libetpan/pull/361
    (fetchpatch {
      name = "pr-361-null-pointer-deference.patch";
      url = "https://github.com/dinhvh/libetpan/commit/0cdefb017fcfd0fae56a151dc14c8439a38ecc44.patch";
      hash = "sha256-qbWisOCPI91AIXzg3n7mceSVbBKHZXd8Z0z1u/SrIG8=";
    })

    # Fix potential null pointer deference
    # https://github.com/dinhvh/libetpan/pull/363
    (fetchpatch {
      name = "pr-363-null-pointer-deference.patch";
      url = "https://github.com/dinhvh/libetpan/commit/68bde8b12b40a680c29d228f0b8fe4dfbf2d8d0b.patch";
      hash = "sha256-dUbnh2RoeELk/usHeFsdGC+J198jcudx3rb6/3sUAX0=";
    })

    # Missing boundary fix
    # https://github.com/dinhvh/libetpan/pull/384
    (fetchpatch {
      name = "pr-384-missing-boundary-fix.patch";
      url = "https://github.com/dinhvh/libetpan/commit/24c485495216c00076b29391591f46b61fcb3dac.patch";
      hash = "sha256-6ry8EfiYgbMtQYtT7L662I1A7N7N6OOy9T2ECgR7+cI=";
    })

    # CVE-2020-15953: Detect extra data after STARTTLS response and exit
    # https://github.com/dinhvh/libetpan/pull/387
    (fetchpatch {
      name = "cve-2020-15953-imap.patch";
      url = "https://github.com/dinhvh/libetpan/commit/1002a0121a8f5a9aee25357769807f2c519fa50b.patch";
      hash = "sha256-dqnHZAzX6ym8uF23iKVotdHQv9XQ/BGBAiRGSb7QLcE=";
    })

    # CVE-2020-15953: Detect extra data after STARTTLS responses in SMTP and POP3 and exit
    # https://github.com/dinhvh/libetpan/pull/388
    (fetchpatch {
      name = "cve-2020-15953-pop3-smtp.patch";
      url = "https://github.com/dinhvh/libetpan/commit/298460a2adaabd2f28f417a0f106cb3b68d27df9.patch";
      hash = "sha256-QI0gvLGUik4TQAz/pxwVfOhZc/xtj6jcWPZkJVsSCFM=";
    })

    # Fix buffer overwrite for empty string in remove_trailing_eol
    # https://github.com/dinhvh/libetpan/pull/408
    (fetchpatch {
      name = "pr-408-fix-buffer-overwrite.patch";
      url = "https://github.com/dinhvh/libetpan/commit/078b924c7f49ac435b10b0f53a73f1bbc4717064.patch";
      hash = "sha256-lBRS+bv/7IK7yat2p3mc0SRYn/wRB/spjE7ungj6DT0=";
    })

    # CVE-2022-4121: Fixed crash when st_info_list is NULL.
    # https://github.com/dinhvh/libetpan/issues/420
    (fetchpatch {
      name = "cve-2022-4121.patch";
      url = "https://github.com/dinhvh/libetpan/commit/5c9eb6b6ba64c4eb927d7a902317410181aacbba.patch";
      hash = "sha256-O+LUkI91oej7MFg4Pg6/xq1uhSanweH81VzPXBdiPh4=";
    })
  ];

  nativeBuildInputs = [ autoconf automake libtool pkg-config ];

  buildInputs = [ openssl ];

  configureScript = "./autogen.sh";

  meta = with lib; {
    description = "Mail Framework for the C Language";
    homepage = "https://www.etpan.org/libetpan.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ oxzi ];
  };
}
