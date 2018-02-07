{ stdenv, fetchFromGitHub, coq, mathcomp }:

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-multinomials-${version}";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "math-comp";
    repo = "multinomials";
    rev = version;
    sha256 = "1qmbxp1h81cy3imh627pznmng0kvv37k4hrwi2faa101s6bcx55m";
  };

  buildInputs = [ coq ];
  propagatedBuildInputs = [ mathcomp ];

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = {
    description = "A Coq/SSReflect Library for Monoidal Rings and Multinomials";
    inherit (src.meta) homepage;
    license = stdenv.lib.licenses.cecill-b;
    inherit (coq.meta) platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.5" "8.6" "8.7" ];
  };
}
