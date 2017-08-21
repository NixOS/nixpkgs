args @ { fetchurl, ... }:
rec {
  baseName = ''caveman'';
  version = ''20170630-git'';

  description = ''Web Application Framework for Common Lisp'';

  deps = [ args."myway" args."local-time" args."do-urlencode" args."clack-v1-compat" args."cl-syntax-annot" args."cl-syntax" args."cl-project" args."cl-ppcre" args."cl-emb" args."anaphora" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/caveman/2017-06-30/caveman-20170630-git.tgz'';
    sha256 = ''0wpjnskcvrgvqn9gbr43yqnpcxfmdggbiyaxz9rrhgcis2rwjkj2'';
  };
    
  packageName = "caveman";

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/caveman[.]asd${"$"}' |
        while read f; do
          env -i \
          NIX_LISP="$NIX_LISP" \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(progn
            (asdf:load-system :$(basename "$f" .asd))
            (asdf:perform (quote asdf:compile-bundle-op) :$(basename "$f" .asd))
            (ignore-errors (asdf:perform (quote asdf:deliver-asd-op) :$(basename "$f" .asd)))
            )'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM caveman DESCRIPTION Web Application Framework for Common Lisp SHA256 0wpjnskcvrgvqn9gbr43yqnpcxfmdggbiyaxz9rrhgcis2rwjkj2 URL
    http://beta.quicklisp.org/archive/caveman/2017-06-30/caveman-20170630-git.tgz MD5 774f85fa78792bde012bad78efff4b53 NAME caveman TESTNAME NIL FILENAME
    caveman DEPS
    ((NAME myway FILENAME myway) (NAME local-time FILENAME local-time) (NAME do-urlencode FILENAME do-urlencode)
     (NAME clack-v1-compat FILENAME clack-v1-compat) (NAME cl-syntax-annot FILENAME cl-syntax-annot) (NAME cl-syntax FILENAME cl-syntax)
     (NAME cl-project FILENAME cl-project) (NAME cl-ppcre FILENAME cl-ppcre) (NAME cl-emb FILENAME cl-emb) (NAME anaphora FILENAME anaphora))
    DEPENDENCIES (myway local-time do-urlencode clack-v1-compat cl-syntax-annot cl-syntax cl-project cl-ppcre cl-emb anaphora) VERSION 20170630-git SIBLINGS
    (caveman-middleware-dbimanager caveman-test caveman2-db caveman2-test caveman2)) */
