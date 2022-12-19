#!/usr/bin/env nix-shell
#! nix-shell -i oil -p oil jq ocaml-ng.ocamlPackages_latest.sexp
export URL_PREFIX="https://code.call-cc.org/egg-tarballs/5/"
cd $(nix-prefetch-url \
     'https://code.call-cc.org/cgi-bin/gitweb.cgi?p=eggs-5-latest.git;a=snapshot;h=master;sf=tgz' \
     --name chicken-eggs-5-latest --unpack --print-path | tail -1)
const eggExpr = '
  def toarray: if type=="array" then . else [.] end;
  if type=="array" then map({(first): .[1:]}) | add else . end |
    {synopsis:     .synopsis | toarray | first | tostring,
     version:      env.EGG_VERSION,
     sha256:       env.EGG_SHA256,
     dependencies: (.dependencies // []) | toarray | map(toarray) | map(first),
     license:      .license | toarray | first | ascii_downcase | sub(" ";"-")}'
for i, item in */*/*.egg {
  var EGG_NAME=$(dirname $(dirname $item))
  var EGG_VERSION=$(basename $(dirname $item))
  var EGG_URL="${URL_PREFIX}${EGG_NAME}/${EGG_NAME}-${EGG_VERSION}.tar.gz"
  var EGG_SHA256=$(nix-prefetch-url $EGG_URL --unpack --name "chicken-${EGG_NAME}-${EGG_VERSION}-source")
  sexp pp < $item | sexp to-json | jq --slurp first | \
    EGG_VERSION=$[EGG_VERSION] EGG_SHA256=$[EGG_SHA256] \
    jq $eggExpr | EGG_NAME=$[EGG_NAME] jq '{($ENV.EGG_NAME): .}'
} | jq --slurp --sort-keys add > $_this_dir/deps.json
