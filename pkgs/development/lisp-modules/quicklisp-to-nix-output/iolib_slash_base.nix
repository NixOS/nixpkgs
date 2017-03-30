args @ { fetchurl, ... }:
rec {
  baseName = ''iolib_slash_base'';
  version = ''iolib-v0.8.1'';

  description = ''Base IOlib package, used instead of CL.'';

  deps = [ args."iolib/common-lisp" args."alexandria" args."split-sequence" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/iolib/2016-03-18/iolib-v0.8.1.tgz'';
    sha256 = ''090xmjzyx5d7arpk9g0fsyblwh6myq2d1cb7w52r3zy1394c9481'';
  };
}
