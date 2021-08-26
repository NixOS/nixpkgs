/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-qprint";
  version = "20150804-git";

  description = "Encode and decode quoted-printable encoded strings.";

  deps = [ args."flexi-streams" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-qprint/2015-08-04/cl-qprint-20150804-git.tgz";
    sha256 = "042nq9airkc4yaqzpmly5iszmkbwfn38wsgi9k361ldf1y54lq28";
  };

  packageName = "cl-qprint";

  asdFilesToKeep = ["cl-qprint.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-qprint DESCRIPTION
    Encode and decode quoted-printable encoded strings. SHA256
    042nq9airkc4yaqzpmly5iszmkbwfn38wsgi9k361ldf1y54lq28 URL
    http://beta.quicklisp.org/archive/cl-qprint/2015-08-04/cl-qprint-20150804-git.tgz
    MD5 74376a69e0b078724c94cc268f69e0f7 NAME cl-qprint FILENAME cl-qprint DEPS
    ((NAME flexi-streams FILENAME flexi-streams)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (flexi-streams trivial-gray-streams) VERSION 20150804-git
    SIBLINGS NIL PARASITES NIL) */
