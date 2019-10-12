args @ { fetchurl, ... }:
{
  baseName = ''clx-truetype'';
  version = ''20160825-git'';

  parasites = [ "clx-truetype-test" ];

  description = ''clx-truetype is pure common lisp solution for antialiased TrueType font rendering using CLX and XRender extension.'';

  deps = [ args."alexandria" args."bordeaux-threads" args."cl-aa" args."cl-fad" args."cl-paths" args."cl-paths-ttf" args."cl-store" args."cl-vectors" args."clx" args."trivial-features" args."zpb-ttf" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clx-truetype/2016-08-25/clx-truetype-20160825-git.tgz'';
    sha256 = ''0ndy067rg9w6636gxwlpnw7f3ck9nrnjb03444pprik9r3c9in67'';
  };

  packageName = "clx-truetype";

  asdFilesToKeep = ["clx-truetype.asd"];
  overrides = x: x;
}
/* (SYSTEM clx-truetype DESCRIPTION
    clx-truetype is pure common lisp solution for antialiased TrueType font rendering using CLX and XRender extension.
    SHA256 0ndy067rg9w6636gxwlpnw7f3ck9nrnjb03444pprik9r3c9in67 URL
    http://beta.quicklisp.org/archive/clx-truetype/2016-08-25/clx-truetype-20160825-git.tgz
    MD5 7c9dedb21d52dedf727de741ac6d9c60 NAME clx-truetype FILENAME
    clx-truetype DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME cl-aa FILENAME cl-aa) (NAME cl-fad FILENAME cl-fad)
     (NAME cl-paths FILENAME cl-paths)
     (NAME cl-paths-ttf FILENAME cl-paths-ttf)
     (NAME cl-store FILENAME cl-store) (NAME cl-vectors FILENAME cl-vectors)
     (NAME clx FILENAME clx) (NAME trivial-features FILENAME trivial-features)
     (NAME zpb-ttf FILENAME zpb-ttf))
    DEPENDENCIES
    (alexandria bordeaux-threads cl-aa cl-fad cl-paths cl-paths-ttf cl-store
     cl-vectors clx trivial-features zpb-ttf)
    VERSION 20160825-git SIBLINGS NIL PARASITES (clx-truetype-test)) */
