{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "md4c";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "mity";
    repo = pname;
    rev = "release-${version}";
    hash = "sha256-+LObAD5JB8Vb4Rt4hTo1Z4ispxzfFkkXA2sw6TKB7Yo=";
  };

  patches = [
    # We set CMAKE_INSTALL_LIBDIR to the absolute path in $out, so
    # prefix and exec_prefix cannot be $out, too
    # Use CMake's _FULL_ variables instead of `prefix` concatenation.
    ./fix-pkgconfig.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = with lib; {
    description = "Markdown parser made in C";
    longDescription = ''
      MD4C is Markdown parser implementation in C, with the following features:

      - Compliance: Generally, MD4C aims to be compliant to the latest version
        of CommonMark specification. Currently, we are fully compliant to
        CommonMark 0.29.
      - Extensions: MD4C supports some commonly requested and accepted
        extensions. See below.
      - Performance: MD4C is very fast.
      - Compactness: MD4C parser is implemented in one source file and one
        header file. There are no dependencies other than standard C library.
      - Embedding: MD4C parser is easy to reuse in other projects, its API is
        very straightforward: There is actually just one function, md_parse().
      - Push model: MD4C parses the complete document and calls few callback
        functions provided by the application to inform it about a start/end of
        every block, a start/end of every span, and with any textual contents.
      - Portability: MD4C builds and works on Windows and POSIX-compliant
        OSes. (It should be simple to make it run also on most other platforms,
        at least as long as the platform provides C standard library, including
        a heap memory management.)
      - Encoding: MD4C by default expects UTF-8 encoding of the input
        document. But it can be compiled to recognize ASCII-only control
        characters (i.e. to disable all Unicode-specific code), or (on Windows)
        to expect UTF-16 (i.e. what is on Windows commonly called just
        "Unicode"). See more details below.
      - Permissive license: MD4C is available under the MIT license.
    '';
    homepage = "https://github.com/mity/md4c";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    mainProgram = "md2html";
    platforms = platforms.all;
  };
}
# TODO: enable tests (needs Python)
