#! /usr/bin/env nix-shell
#! nix-shell -i bash -p jq

set -eo pipefail

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPTDIR

TOP_N_FILE=$(nix build --impure -f top-julia-packages.nix --no-link --json | jq -r '.[0].outputs.out')
echo "Got top Julia packages: $TOP_N_FILE"

TESTER_PROGRAM=$(nix build --impure --expr 'with import ../../../../. {}; haskellPackages.callPackage ./julia-top-n {}' --no-link --json | jq -r '.[0].outputs.out')/bin/julia-top-n-exe
echo "Built tester program: $TESTER_PROGRAM"

"$TESTER_PROGRAM" --tui -c "$TOP_N_FILE" $*
