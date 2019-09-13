args @ { fetchurl, ... }:
{
  baseName = ''cffi-grovel'';
  version = ''cffi_0.20.1'';

  description = ''The CFFI Groveller'';

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-toolchain" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cffi/2019-07-10/cffi_0.20.1.tgz'';
    sha256 = ''0ppcwc61ww1igmkwpvzpr9hzsl8wpf8acxlamq5r0604iz07qhka'';
  };

  packageName = "cffi-grovel";

  asdFilesToKeep = ["cffi-grovel.asd"];
  overrides = x: x;
}
/* (SYSTEM cffi-grovel DESCRIPTION The CFFI Groveller SHA256
    0ppcwc61ww1igmkwpvzpr9hzsl8wpf8acxlamq5r0604iz07qhka URL
    http://beta.quicklisp.org/archive/cffi/2019-07-10/cffi_0.20.1.tgz MD5
    b8a8337465a7b4c1be05270b777ce14f NAME cffi-grovel FILENAME cffi-grovel DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel cffi cffi-toolchain trivial-features)
    VERSION cffi_0.20.1 SIBLINGS
    (cffi-examples cffi-libffi cffi-tests cffi-toolchain cffi-uffi-compat cffi)
    PARASITES NIL) */
