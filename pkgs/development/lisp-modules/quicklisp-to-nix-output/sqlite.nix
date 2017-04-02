args @ { fetchurl, ... }:
rec {
  baseName = ''sqlite'';
  version = ''cl-20130615-git'';

  description = '''';

  deps = [ args."cffi" args."iterate" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-sqlite/2013-06-15/cl-sqlite-20130615-git.tgz'';
    sha256 = ''0db1fvvnsrnxmp272ycnl2kwhymjwrimr8z4djvjlg6cvjxk6lqh'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/sqlite[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM sqlite DESCRIPTION NIL SHA256 0db1fvvnsrnxmp272ycnl2kwhymjwrimr8z4djvjlg6cvjxk6lqh URL
    http://beta.quicklisp.org/archive/cl-sqlite/2013-06-15/cl-sqlite-20130615-git.tgz MD5 93be7c68f587d830941be55f2c2f1c8b NAME sqlite TESTNAME NIL FILENAME
    sqlite DEPS ((NAME cffi) (NAME iterate)) DEPENDENCIES (cffi iterate) VERSION cl-20130615-git SIBLINGS NIL) */
