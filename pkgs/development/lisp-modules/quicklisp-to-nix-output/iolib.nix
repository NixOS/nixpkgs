args @ { fetchurl, ... }:
rec {
  baseName = ''iolib'';
  version = ''v0.8.1'';

  description = ''I/O library.'';

  deps = [ args."alexandria" args."babel" args."bordeaux-threads" args."cffi" args."idna" args."split-sequence" args."swap-bytes" args."trivial-features" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/iolib/2016-03-18/iolib-v0.8.1.tgz'';
    sha256 = ''090xmjzyx5d7arpk9g0fsyblwh6myq2d1cb7w52r3zy1394c9481'';
  };

  overrides = x: {
  };
}
