{ stdenv, fetchFromGitHub, coq }:

let
  versions = {
    pre_8_9 = {
      owner   = "gmalecha";
      rev     = "1.2.0";
      version = "1.2.0";
      sha256  = "0h5m04flqfk0v577syw0v1dw2wf7xrx6jaxv5gpmqzssf5hxafy4";
    };
    post_8_9 = {
      owner   = "Ptival";
      rev     = "bd7082a3571ee3c111096ff6b5eb28c8d3a99ce5";
      version = "1.2.0+8.9-fix";
      sha256  = "0625qd8pyxi0v704fwnawrfw5fk966vnk120il0g6qv42siyck95";
    };
  };
  params =
    {
      "8.5"  = versions.pre_8_9;
      "8.6"  = versions.pre_8_9;
      "8.7"  = versions.pre_8_9;
      "8.8"  = versions.pre_8_9;
      "8.9"  = versions.post_8_9;
      "8.10" = versions.post_8_9;
    };
  param = params.${coq.coq-version};
in

stdenv.mkDerivation rec {
  inherit (param) version;
  name = "coq${coq.coq-version}-coq-extensible-records-${version}";

  src = fetchFromGitHub {
    inherit (param) owner rev sha256;
    repo = "coq-extensible-records";
  };

  buildInputs = [ coq ];

  enableParallelBuilding = true;

  installPhase = ''
    make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/gmalecha/coq-extensible-records;
    description = "Implementation of extensible records in Coq";
    license = licenses.mit;
    maintainers = with maintainers; [ ptival ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.5" "8.6" "8.7" "8.8" "8.9" "8.10" ];
  };
}
