/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "vecto";
  version = "1.5";

  description = "Create vector graphics in PNG files.";

  deps = [ args."cl-aa" args."cl-paths" args."cl-vectors" args."salza2" args."trivial-gray-streams" args."zpb-ttf" args."zpng" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/vecto/2017-12-27/vecto-1.5.tgz";
    sha256 = "05pxc6s853f67j57bbzsg2izfl0164bifbvdp2ji870yziz88vls";
  };

  packageName = "vecto";

  asdFilesToKeep = ["vecto.asd"];
  overrides = x: x;
}
/* (SYSTEM vecto DESCRIPTION Create vector graphics in PNG files. SHA256
    05pxc6s853f67j57bbzsg2izfl0164bifbvdp2ji870yziz88vls URL
    http://beta.quicklisp.org/archive/vecto/2017-12-27/vecto-1.5.tgz MD5
    69e6b2f7fa10066d50f9134942afad73 NAME vecto FILENAME vecto DEPS
    ((NAME cl-aa FILENAME cl-aa) (NAME cl-paths FILENAME cl-paths)
     (NAME cl-vectors FILENAME cl-vectors) (NAME salza2 FILENAME salza2)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams)
     (NAME zpb-ttf FILENAME zpb-ttf) (NAME zpng FILENAME zpng))
    DEPENDENCIES
    (cl-aa cl-paths cl-vectors salza2 trivial-gray-streams zpb-ttf zpng)
    VERSION 1.5 SIBLINGS (vectometry) PARASITES NIL) */
