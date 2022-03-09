{ lib, fetchFromGitHub, buildDunePackage, ocaml, cppo }:

buildDunePackage rec {
  pname = "camomile";
  version = "1.0.2";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "yoriyuki";
    repo = pname;
    rev = version;
    sha256 = "00i910qjv6bpk0nkafp5fg97isqas0bwjf7m6rz11rsxilpalzad";
  };

  nativeBuildInputs = [ cppo ];

  strictDeps = true;

  configurePhase = ''
    runHook preConfigure
    ocaml configure.ml --share $out/share/camomile
    runHook postConfigure
  '';

  postInstall = ''
    echo "version = \"${version}\"" >> $out/lib/ocaml/${ocaml.version}/site-lib/camomile/META
  '';

  meta = {
    inherit (src.meta) homepage;
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.lgpl21;
    description = "A Unicode library for OCaml";
  };
}
