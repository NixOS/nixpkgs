#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE[0]}")"
cabal2nix cabal://hercules-ci-agent-0.9.13 >hercules-ci-agent.nix
cabal2nix cabal://hercules-ci-api-0.8.1.0 >hercules-ci-api.nix
cabal2nix cabal://hercules-ci-api-agent-0.5.0.1 >hercules-ci-api-agent.nix
cabal2nix cabal://hercules-ci-api-core-0.1.5.1 >hercules-ci-api-core.nix
cabal2nix cabal://hercules-ci-cli-0.3.6.1 >hercules-ci-cli.nix
cabal2nix cabal://hercules-ci-cnix-expr-0.3.6.1 >hercules-ci-cnix-expr.nix
cabal2nix cabal://hercules-ci-cnix-store-0.3.5.0 >hercules-ci-cnix-store.nix
