{
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildDunePackage,
  base,
  ppx_sexp_conv,
}:

buildDunePackage rec {
  pname = "tdigest";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "SGrondin";
    repo = pname;
    rev = version;
    sha256 = "sha256-faJ8ZQ7AWDHWfyQ2jq6+8TMe4G4NLjqHxYzLzt2LGh4=";
  };

  minimalOCamlVersion = "5.1";

  # base v0.17 compatibility
  patches = [ ./tdigest.patch ];

  propagatedBuildInputs = [
    base
    ppx_sexp_conv
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/SGrondin/${pname}";
    description = "OCaml implementation of the T-Digest algorithm";
    license = licenses.mit;
    maintainers = with maintainers; [ niols ];
  };
}
