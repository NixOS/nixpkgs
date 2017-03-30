args @ { fetchurl, ... }:
rec {
  baseName = ''iolib_slash_sockets'';
  version = ''iolib-v0.8.1'';

  description = ''Socket library.'';

  deps = [ args."iolib/base" args."iolib/syscalls" args."iolib/streams" args."babel" args."cffi" args."iolib/grovel" args."bordeaux-threads" args."idna" args."swap-bytes" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/iolib/2016-03-18/iolib-v0.8.1.tgz'';
    sha256 = ''090xmjzyx5d7arpk9g0fsyblwh6myq2d1cb7w52r3zy1394c9481'';
  };
}
