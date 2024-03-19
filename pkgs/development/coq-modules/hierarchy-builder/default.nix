{ lib, mkCoqDerivation, coq, coq-elpi, version ? null }:

let hb = mkCoqDerivation {
  pname = "hierarchy-builder";
  owner = "math-comp";
  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = range "8.18" "8.19"; out = "1.7.0"; }
    { case = range "8.16" "8.18"; out = "1.6.0"; }
    { case = range "8.15" "8.18"; out = "1.5.0"; }
    { case = range "8.15" "8.17"; out = "1.4.0"; }
    { case = range "8.13" "8.14"; out = "1.2.0"; }
    { case = range "8.12" "8.13"; out = "1.1.0"; }
    { case = isEq "8.11";         out = "0.10.0"; }
  ] null;
  release."1.7.0".sha256  = "sha256-WqSeuJhmqicJgXw/xGjGvbRzfyOK7rmkVRb6tPDTAZg=";
  release."1.6.0".sha256  = "sha256-E8s20veOuK96knVQ7rEDSt8VmbtYfPgItD0dTY/mckg=";
  release."1.5.0".sha256  = "sha256-Lia3o156Pbe8rDHOA1IniGYsG5/qzZkzDKdHecfmS+c=";
  release."1.4.0".sha256  = "sha256-tOed9UU3kMw6KWHJ5LVLUFEmzHx1ImutXQvZ0ldW9rw=";
  release."1.3.0".sha256  = "17k7rlxdx43qda6i1yafpgc64na8br285cb0mbxy5wryafcdrkrc";
  release."1.2.1".sha256  = "sha256-pQYZJ34YzvdlRSGLwsrYgPdz3p/l5f+KhJjkYT08Mj0=";
  release."1.2.0".sha256  = "0sk01rvvk652d86aibc8rik2m8iz7jn6mw9hh6xkbxlsvh50719d";
  release."1.1.0".sha256  = "sha256-spno5ty4kU4WWiOfzoqbXF8lWlNSlySWcRReR3zE/4Q=";
  release."1.0.0".sha256  = "0yykygs0z6fby6vkiaiv3azy1i9yx4rqg8xdlgkwnf2284hffzpp";
  release."0.10.0".sha256 = "1a3vry9nzavrlrdlq3cys3f8kpq3bz447q8c4c7lh2qal61wb32h";
  releaseRev = v: "v${v}";

  propagatedBuildInputs = [ coq-elpi ];

  mlPlugin = true;

  extraInstallFlags = [ "VFILES=structures.v" ];

  meta = with lib; {
    description = "High level commands to declare a hierarchy based on packed classes";
    maintainers = with maintainers; [ cohencyril siraben ];
    license = licenses.mit;
  };
}; in
hb.overrideAttrs (o:
  lib.optionalAttrs (lib.versions.isGe "1.2.0" o.version || o.version == "dev")
    { buildPhase = "make build"; }
  //
  lib.optionalAttrs (lib.versions.isGe "1.1.0" o.version || o.version == "dev")
  { installFlags = [ "DESTDIR=$(out)" ] ++ o.installFlags; }
)
