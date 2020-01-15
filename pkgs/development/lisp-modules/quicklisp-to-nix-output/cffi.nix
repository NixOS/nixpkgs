args @ { fetchurl, ... }:
{
  baseName = ''cffi'';
  version = ''cffi_0.20.1'';

  parasites = [ "cffi/c2ffi" "cffi/c2ffi-generator" ];

  description = ''The Common Foreign Function Interface'';

  deps = [ args."alexandria" args."babel" args."cl-json" args."cl-ppcre" args."trivial-features" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cffi/2019-07-10/cffi_0.20.1.tgz'';
    sha256 = ''0ppcwc61ww1igmkwpvzpr9hzsl8wpf8acxlamq5r0604iz07qhka'';
  };

  packageName = "cffi";

  asdFilesToKeep = ["cffi.asd"];
  overrides = x: x;
}
/* (SYSTEM cffi DESCRIPTION The Common Foreign Function Interface SHA256
    0ppcwc61ww1igmkwpvzpr9hzsl8wpf8acxlamq5r0604iz07qhka URL
    http://beta.quicklisp.org/archive/cffi/2019-07-10/cffi_0.20.1.tgz MD5
    b8a8337465a7b4c1be05270b777ce14f NAME cffi FILENAME cffi DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-json FILENAME cl-json) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME trivial-features FILENAME trivial-features)
     (NAME uiop FILENAME uiop))
    DEPENDENCIES (alexandria babel cl-json cl-ppcre trivial-features uiop)
    VERSION cffi_0.20.1 SIBLINGS
    (cffi-examples cffi-grovel cffi-libffi cffi-tests cffi-toolchain
     cffi-uffi-compat)
    PARASITES (cffi/c2ffi cffi/c2ffi-generator)) */
