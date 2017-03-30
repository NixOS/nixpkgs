args @ { fetchurl, ... }:
rec {
  baseName = ''iolib_slash_multiplex'';
  version = ''iolib-v0.8.1'';

  description = ''I/O multiplexing library.'';

  deps = [ args."iolib/base" args."iolib/syscalls" args."cffi" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/iolib/2016-03-18/iolib-v0.8.1.tgz'';
    sha256 = ''090xmjzyx5d7arpk9g0fsyblwh6myq2d1cb7w52r3zy1394c9481'';
  };
}
