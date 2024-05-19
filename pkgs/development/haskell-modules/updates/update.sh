#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

cabal2nix cabal://hercules-ci-api-core-0.1.7.0 > hercules-ci-api-core.nix
cabal2nix cabal://hercules-ci-api-agent-0.5.1.0 > hercules-ci-api-agent.nix
cabal2nix cabal://hercules-ci-api-0.8.4.0 > hercules-ci-api.nix
cabal2nix cabal://hercules-ci-agent-0.10.3 > hercules-ci-agent.nix
cabal2nix cabal://hercules-ci-cli-0.3.7 > hercules-ci-cli.nix
cabal2nix cabal://hercules-ci-cnix-expr-0.3.6.3 > hercules-ci-cnix-expr.nix
cabal2nix cabal://hercules-ci-cnix-store-0.3.6.0 > hercules-ci-cnix-store.nix
