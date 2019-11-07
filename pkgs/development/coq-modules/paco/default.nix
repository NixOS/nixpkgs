{ stdenv, fetchFromGitHub, coq, unzip, version ? null }:

let
  paco-versions = {
    "1_2_8" = rec {
      rev = "v${version}";
      version = "1.2.8";
      sha256 = "05fskx5x1qgaf9qv626m38y5izichzzqc7g2rglzrkygbskrrwsb";
    };
    "2_1_0" = rec {
      rev = "v${version}";
      version = "2.1.0";
      sha256 = "0dra0wigdrr6sdy1c76b0v8pvkd447ri5r59vrvab1ww9rk7y2da";
    };
    "3_0_0" = rec {
      rev = "v${version}";
      version = "3.0.0";
      sha256 = "1riqycr4wkzsgybn143066vk71w1n2i889ffc3a9j9y5f9bbn2pd";
    };
    "4_0_0" = rec {
      rev = "v${version}";
      version = "4.0.0";
      sha256 = "1ncrdyijkgf0s2q4rg1s9r2nrcb17gq3jz63iqdlyjq3ylv8gyx0";
    };
  };
  default-versions = {
    "8.5" = paco-versions."1_2_8";
    "8.6" = paco-versions."4_0_0";
    "8.7" = paco-versions."4_0_0";
    "8.8" = paco-versions."4_0_0";
    "8.9" = paco-versions."4_0_0";
  };
  param =
    if version == null
    then default-versions.${coq.coq-version}
    else paco-versions.${version};
in

stdenv.mkDerivation rec {
  inherit (param) version;
  name = "coq-paco-${coq.coq-version}-${version}";

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
    compatibleCoqVersions = v: builtins.hasAttr v default-versions;
  };

}
