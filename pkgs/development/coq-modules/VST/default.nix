{ stdenv, fetchFromGitHub, coq, compcert }:

stdenv.mkDerivation rec {
  pname = "coq${coq.coq-version}-VST";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "PrincetonUniversity";
    repo = "VST";
    rev = "v${version}";
    sha256 = "00bf9hl4pvmsqa08lzjs1mrxyfgfxq4k6778pnldmc8ichm90jgk";
  };

  buildInputs = [ coq ];
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

  enableParallelBuilding = true;

  passthru.compatibleCoqVersions = stdenv.lib.flip builtins.elem [ "8.11" ];

  meta = {
    description = "Verified Software Toolchain";
    homepage = "https://vst.cs.princeton.edu/";
    inherit (compcert.meta) platforms;
  };

}
