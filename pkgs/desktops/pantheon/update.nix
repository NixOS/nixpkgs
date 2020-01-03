{ nixpkgs-github-update }:

{ attrPath }:


[ "${nixpkgs-github-update}/bin/nixpkgs_github_update" "--attribute" attrPath ]
