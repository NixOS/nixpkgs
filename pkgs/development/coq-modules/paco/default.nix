{stdenv, fetchFromGitHub, coq, unzip}:

let
  versions = {
    pre_8_6 = rec {
      rev = "v${version}";
      version = "1.2.8";
      sha256 = "05fskx5x1qgaf9qv626m38y5izichzzqc7g2rglzrkygbskrrwsb";
    };
    post_8_6 = rec {
      rev = "v${version}";
      version = "4.0.0";
      sha256 = "1ncrdyijkgf0s2q4rg1s9r2nrcb17gq3jz63iqdlyjq3ylv8gyx0";
    };
  };
  params = {
    "8.5" = versions.pre_8_6;
    "8.6" = versions.post_8_6;
    "8.7" = versions.post_8_6;
    "8.8" = versions.post_8_6;
    "8.9" = versions.post_8_6;
    "8.10" = versions.post_8_6;
    "8.11" = versions.post_8_6;
  };
  param = params.${coq.coq-version};
in

stdenv.mkDerivation rec {
  inherit (param) version;
  name = "coq${coq.coq-version}-paco-${version}";

  src = fetchFromGitHub {
    inherit (param) rev sha256;
    owner = "snu-sf";
    repo = "paco";
  };

  buildInputs = with coq.ocamlPackages; [ ocaml camlp5 unzip ];
  propagatedBuildInputs = [ coq ];

  preBuild = "cd src";

  installPhase = ''
    COQLIB=$out/lib/coq/${coq.coq-version}/
    mkdir -p $COQLIB/user-contrib/Paco
    cp -pR *.vo $COQLIB/user-contrib/Paco
  '';

  meta = with stdenv.lib; {
    homepage = http://plv.mpi-sws.org/paco/;
    description = "A Coq library implementing parameterized coinduction";
    maintainers = with maintainers; [ jwiegley ptival ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = stdenv.lib.flip builtins.hasAttr params;
  };

}
