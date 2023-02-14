/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "vecto";
  version = "1.6";

  description = "Create vector graphics in PNG files.";

  deps = [ args."cl-aa" args."cl-paths" args."cl-vectors" args."salza2" args."trivial-gray-streams" args."zpb-ttf" args."zpng" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/vecto/2021-12-30/vecto-1.6.tgz";
    sha256 = "09iis5v95gybypxrmqll1fifclqzmg5blaxcr59bwbb72ihvi790";
  };

  packageName = "vecto";

  asdFilesToKeep = ["vecto.asd"];
  overrides = x: x;
}
/* (SYSTEM vecto DESCRIPTION Create vector graphics in PNG files. SHA256
    09iis5v95gybypxrmqll1fifclqzmg5blaxcr59bwbb72ihvi790 URL
    http://beta.quicklisp.org/archive/vecto/2021-12-30/vecto-1.6.tgz MD5
    9b7f7ddb9cc4d8de353979e339182c31 NAME vecto FILENAME vecto DEPS
    ((NAME cl-aa FILENAME cl-aa) (NAME cl-paths FILENAME cl-paths)
     (NAME cl-vectors FILENAME cl-vectors) (NAME salza2 FILENAME salza2)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME zpb-ttf FILENAME zpb-ttf) (NAME zpng FILENAME zpng))
    DEPENDENCIES
    (cl-aa cl-paths cl-vectors salza2 trivial-gray-streams zpb-ttf zpng)
    VERSION 1.6 SIBLINGS (vectometry) PARASITES NIL) */
