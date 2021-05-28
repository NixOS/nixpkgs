{ stdenv, fetchFromGitHub, coq }:

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-metalib-${version}";
  version = "20200527";

  src = fetchFromGitHub {
    owner = "plclub";
    repo = "metalib";
    rev = "597fd7d0c93eb159274e84a39d554f10f1efccf8";
    sha256 = "0wbypc05d2lqfm9qaw98ynr5yc1p0ipsvyc3bh1rk9nz7zwirmjs";
  };

  sourceRoot = "source/Metalib";

  buildInputs = [ coq ];

  enableParallelBuilding = true;

  installFlags = "COQMF_COQLIB=$(out)/lib/coq/${coq.coq-version}";

  meta = with stdenv.lib; {
    homepage = "https://github.com/plclub/metalib";
    license = licenses.mit;
    maintainers = [ maintainers.jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.10" "8.11" "8.12" ];
  };

}
