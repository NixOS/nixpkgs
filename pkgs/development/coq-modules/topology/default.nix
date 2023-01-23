{ lib, mkCoqDerivation, coq, mathcomp, zorns-lemma, version ? null }:
with lib;

mkCoqDerivation rec {
  pname = "topology";

  releaseRev = v: "v${v}";

  release."9.0.0".sha256 = "sha256:03lgy53xg9pmrdd3d8qb4087k5qjnk260655svp6d79x4p2lxr8c";
  release."8.12.0".sha256 = "sha256-ypHmHwzwZ6MQPYwuS3QyZmVOEPUCSbO2lhVaA6TypgQ=";
  release."8.10.0".sha256 = "sha256-mCLF3JYIiO3AEW9yvlcLeF7zN4SjW3LG+Y5vYB0l55A=";
  release."8.9.0".sha256 = "sha256-ZJh1BM34iZOQ75zqLIA+KtBjO2y33y0UpAw/ydCWQYc=";
  release."8.8.0".sha256 = "sha256-Yfm3UymEP1e+BKMNPhdRFLdFhynMirtQ8E0HXnRiqHU=";
  release."8.7.0".sha256 = "sha256-qcZQKvMRs5wWIAny8ciF9TrmEQfKKO9fWhwIRL+s7VA=";
  release."8.6.0".sha256 = "sha256-eu/dBEFo3y6vnXlJljUD4hds6+qgAPQVvsuspyGHcj8=";

  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = range "8.10" "8.16"; out = "9.0.0"; }
    { case = "8.9"; out = "8.9.0"; }
    { case = "8.8"; out = "8.8.0"; }
    { case = "8.7"; out = "8.7.0"; }
    { case = "8.6"; out = "8.6.0"; }
  ] null;

  propagatedBuildInputs = [ zorns-lemma ];

  useDuneifVersion = versions.isGe "9.0";

  meta = {
    description = "General topology in Coq";
    longDescription = ''
      This library develops some of the basic concepts and results of
      general topology in Coq.
    '';
    maintainers = with maintainers; [ siraben ];
    license = licenses.lgpl21Plus;
  };
}
