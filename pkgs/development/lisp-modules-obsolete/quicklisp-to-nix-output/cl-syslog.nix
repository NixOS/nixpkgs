/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-syslog";
  version = "20190202-git";

  description = "Common Lisp syslog interface.";

  deps = [ args."alexandria" args."babel" args."cffi" args."global-vars" args."local-time" args."split-sequence" args."trivial-features" args."usocket" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-syslog/2019-02-02/cl-syslog-20190202-git.tgz";
    sha256 = "1kzz613y9fvx33svlwc65vjaj1cafnxz8icds80ww7il7y6alwgh";
  };

  packageName = "cl-syslog";

  asdFilesToKeep = ["cl-syslog.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-syslog DESCRIPTION Common Lisp syslog interface. SHA256
    1kzz613y9fvx33svlwc65vjaj1cafnxz8icds80ww7il7y6alwgh URL
    http://beta.quicklisp.org/archive/cl-syslog/2019-02-02/cl-syslog-20190202-git.tgz
    MD5 eafff19eb1f38a36a9535c729d2217fe NAME cl-syslog FILENAME cl-syslog DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME global-vars FILENAME global-vars)
     (NAME local-time FILENAME local-time)
     (NAME split-sequence FILENAME split-sequence)
     (NAME trivial-features FILENAME trivial-features)
     (NAME usocket FILENAME usocket))
    DEPENDENCIES
    (alexandria babel cffi global-vars local-time split-sequence
     trivial-features usocket)
    VERSION 20190202-git SIBLINGS NIL PARASITES NIL) */
