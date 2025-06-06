{ stdenv, lib, fetchFromGitHub, perl, gmp, mpfr, ppl, ocaml, findlib, camlidl, mlgmpidl
, flint, pplite
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-apron";
  version = "0.9.15";
  src = fetchFromGitHub {
    owner = "antoinemine";
    repo = "apron";
    rev = "v${version}";
    hash = "sha256-gHLCurydxX1pS66DTAWUJGl9Yqu9RWRjkZh6lXzM7YY=";
  };

  nativeBuildInputs = [ ocaml findlib perl ];
  buildInputs = [ gmp mpfr ppl camlidl flint pplite ];
  propagatedBuildInputs = [ mlgmpidl ];

  outputs = [ "out" "dev" ];

  configurePhase = ''
    runHook preConfigure
    ./configure -prefix $out ${lib.optionalString stdenv.isDarwin "--no-strip"}
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs
    runHook postConfigure
  '';

  postInstall = ''
    mkdir -p $dev/lib
    mv $out/lib/ocaml $dev/lib/
  '';

  meta = {
    license = lib.licenses.lgpl21;
    homepage = "http://apron.cri.ensmp.fr/library/";
    maintainers = [ lib.maintainers.vbgl ];
    description = "Numerical abstract domain library";
    inherit (ocaml.meta) platforms;
  };
}
