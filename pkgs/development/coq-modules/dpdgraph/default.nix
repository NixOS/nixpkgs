{ lib, mkCoqDerivation, autoreconfHook, coq, version ? null }:

with lib;
let hasWarning = versionAtLeast coq.ocamlPackages.ocaml.version "4.08"; in

mkCoqDerivation {
  pname = "dpdgraph";
  owner = "Karmaki";
  repo = "coq-dpdgraph";
  inherit version;
  defaultVersion = switch coq.coq-version [
    { case = "8.13"; out = "0.6.9"; }
    { case = "8.12"; out = "0.6.8"; }
    { case = "8.11"; out = "0.6.7"; }
    { case = "8.10"; out = "0.6.6"; }
    { case = "8.9";  out = "0.6.5"; }
    { case = "8.8";  out = "0.6.3"; }
    { case = "8.7";  out = "0.6.2"; }
    { case = "8.6";  out = "0.6.1"; }
    { case = "8.5";  out = "0.6"; }
  ] null;

  release."0.6.9".sha256 = "11mbydpcgk7y8pqzickbzx0ig7g9k9al71i9yfrcscd2xj8fwj8z";
  release."0.6.8".sha256 = "1mj6sknsd53xfb387sp3kdwvl4wn80ck24bfzf3s6mgw1a12vyps";
  release."0.6.7".sha256 = "01vpi7scvkl4ls1z2k2x9zd65wflzb667idj759859hlz3ps9z09";
  release."0.6.6".sha256 = "1gjrm5zjzw4cisiwdr5b3iqa7s4cssa220xr0k96rwgk61rcjd8w";
  release."0.6.5".sha256 = "1f34z24yg05b1096gqv36jr3vffkcjkf9qncii3pzhhvagxd0w2f";
  release."0.6.3".rev    = "0acbd0a594c7e927574d5f212cc73a486b5305d2";
  release."0.6.3".sha256 = "0c95b0bz2kjm6swr5na4gs06lxxywradszxbr5ldh2zx02r3f3rx";
  release."0.6.2".rev    = "d76ddde37d918569945774733b7997e8b24daf51";
  release."0.6.2".sha256 = "04lnf4b25yarysj848cfl8pd3i3pr3818acyp9hgwdgd1rqmhjwm";
  release."0.6.1".rev    = "c3b87af6bfa338e18b83f014ebd0e56e1f611663";
  release."0.6.1".sha256 = "1jaafkwsb5450378nprjsds1illgdaq60gryi8kspw0i25ykz2c9";
  release."0.6".sha256   = "0qvar8gfbrcs9fmvkph5asqz4l5fi63caykx3bsn8zf0xllkwv0n";
  releaseRev = v: "v${v}";

  nativeBuildInputs = [ autoreconfHook ];
  mlPlugin = true;
  extraBuildInputs = [ coq.ocamlPackages.ocamlgraph ];

  # dpd_compute.ml uses deprecated Pervasives.compare
  # Versions prior to 0.6.5 do not have the WARN_ERR build flag
  preConfigure = optionalString hasWarning ''
    substituteInPlace Makefile.in --replace "-warn-error +a " ""
  '';

  buildFlags = optional hasWarning "WARN_ERR=";

  preInstall = ''
    mkdir -p $out/bin
  '';

  extraInstallFlags = [ "BINDIR=$(out)/bin" ];

  meta = {
    description = "Build dependency graphs between Coq objects";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ vbgl ];
  };
}
