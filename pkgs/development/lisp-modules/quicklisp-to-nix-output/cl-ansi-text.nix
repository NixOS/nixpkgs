args @ { fetchurl, ... }:
rec {
  baseName = ''cl-ansi-text'';
  version = ''20150804-git'';

  description = ''ANSI control string characters, focused on color'';

  deps = [ args."alexandria" args."anaphora" args."cl-colors" args."let-plus" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-ansi-text/2015-08-04/cl-ansi-text-20150804-git.tgz'';
    sha256 = ''112w7qg8yp28qyc2b5c7km457krr3xksxyps1icmgdpqf9ccpn2i'';
  };

  packageName = "cl-ansi-text";

  asdFilesToKeep = ["cl-ansi-text.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-ansi-text DESCRIPTION
    ANSI control string characters, focused on color SHA256
    112w7qg8yp28qyc2b5c7km457krr3xksxyps1icmgdpqf9ccpn2i URL
    http://beta.quicklisp.org/archive/cl-ansi-text/2015-08-04/cl-ansi-text-20150804-git.tgz
    MD5 70aa38b40377a5e89a7f22bb68b3f796 NAME cl-ansi-text FILENAME
    cl-ansi-text DEPS
    ((NAME alexandria FILENAME alexandria) (NAME anaphora FILENAME anaphora)
     (NAME cl-colors FILENAME cl-colors) (NAME let-plus FILENAME let-plus))
    DEPENDENCIES (alexandria anaphora cl-colors let-plus) VERSION 20150804-git
    SIBLINGS (cl-ansi-text-test) PARASITES NIL) */
