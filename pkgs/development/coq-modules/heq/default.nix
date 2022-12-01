{lib, fetchzip, mkCoqDerivation, coq, version ? null }:

let fetcher = {rev, repo, owner, sha256, domain, ...}:
  fetchzip {
    url = "https://${domain}/${owner}/${repo}/download/${repo}-${rev}.zip";
    inherit sha256;
   }; in
with lib; mkCoqDerivation {
  pname = "heq";
  repo = "Heq";
  owner = "gil.hur";
  domain = "sf.snu.ac.kr";
  inherit version fetcher;
  defaultVersion = if versions.isLt "8.8" coq.coq-version then "0.92" else null;
  release."0.92".sha256 = "0cf8y6728n81wwlbpq3vi7l2dbzi7759klypld4gpsjjp1y1fj74";

  mlPlugin = true;
  preBuild = "cd src";

  extraInstallFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  meta = {
    homepage = "https://ropas.snu.ac.kr/~gil.hur/Heq/";
    description = "Heq : a Coq library for Heterogeneous Equality";
    maintainers = with maintainers; [ jwiegley ];
  };
}
