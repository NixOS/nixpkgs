{ lib, mkCoqDerivation, coq, compcert, version ? null }:

with lib; mkCoqDerivation {
  pname = "coq${coq.coq-version}-VST";
  namePrefix = [];
  displayVersion = { coq = false; };
  owner = "PrincetonUniversity";
  repo = "VST";
  inherit version;
  defaultVersion = if coq.coq-version == "8.11" then "2.6" else null;
  release."2.6".sha256 = "00bf9hl4pvmsqa08lzjs1mrxyfgfxq4k6778pnldmc8ichm90jgk";
  releaseRev = v: "v${v}";
  propagatedBuildInputs = [ compcert ];

  preConfigure = "patchShebangs util";

  makeFlags = [
    "BITSIZE=64"
    "COMPCERT=inst_dir"
    "COMPCERT_INST_DIR=${compcert.lib}/lib/coq/${coq.coq-version}/user-contrib/compcert"
    "INSTALLDIR=$(out)/lib/coq/${coq.coq-version}/user-contrib/VST"
  ];

  postInstall = ''
    for d in msl veric floyd sepcomp progs64
    do
      cp -r $d $out/lib/coq/${coq.coq-version}/user-contrib/VST/
    done
  '';

  meta = {
    description = "Verified Software Toolchain";
    homepage = "https://vst.cs.princeton.edu/";
    inherit (compcert.meta) platforms;
  };
}
