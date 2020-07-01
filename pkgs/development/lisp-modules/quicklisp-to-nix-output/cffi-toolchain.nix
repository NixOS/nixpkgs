args @ { fetchurl, ... }:
rec {
  baseName = ''cffi-toolchain'';
  version = ''cffi_0.20.1'';

  description = ''The CFFI toolchain'';

  deps = [ args."alexandria" args."babel" args."cffi" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cffi/2019-07-10/cffi_0.20.1.tgz'';
    sha256 = ''0ppcwc61ww1igmkwpvzpr9hzsl8wpf8acxlamq5r0604iz07qhka'';
  };

  packageName = "cffi-toolchain";

  asdFilesToKeep = ["cffi-toolchain.asd"];
  overrides = x: x;
}
/* (SYSTEM cffi-toolchain DESCRIPTION The CFFI toolchain SHA256
    0ppcwc61ww1igmkwpvzpr9hzsl8wpf8acxlamq5r0604iz07qhka URL
    http://beta.quicklisp.org/archive/cffi/2019-07-10/cffi_0.20.1.tgz MD5
    b8a8337465a7b4c1be05270b777ce14f NAME cffi-toolchain FILENAME
    cffi-toolchain DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel cffi trivial-features) VERSION cffi_0.20.1
    SIBLINGS
    (cffi-examples cffi-grovel cffi-libffi cffi-tests cffi-uffi-compat cffi)
    PARASITES NIL) */
