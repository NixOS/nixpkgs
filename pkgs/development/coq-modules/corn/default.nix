{ stdenv, fetchFromGitHub, coq, bignums, math-classes }:

stdenv.mkDerivation rec {
  pname = "corn";
  version = "8.8.1";
  name = "coq${coq.coq-version}-${pname}-${version}";
  src = fetchFromGitHub {
    owner = "coq-community";
    repo = pname;
    rev = version;
    sha256 = "0gh32j0f18vv5lmf6nb87nr5450w6ai06rhrnvlx2wwi79gv10wp";
  };

  buildInputs = [ coq ];

  preConfigure = "patchShebangs ./configure.sh";
  configureScript = "./configure.sh";
  dontAddPrefix = true;

  propagatedBuildInputs = [ bignums math-classes ];

  enableParallelBuilding = true;

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  meta = {
    homepage = http://c-corn.github.io/;
    license = stdenv.lib.licenses.gpl2;
    description = "A Coq library for constructive analysis";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (coq.meta) platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.6" "8.7" "8.8" "8.9" ];
  };

}
