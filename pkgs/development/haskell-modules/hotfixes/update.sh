#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE[0]}")"
cabal2nix cabal://hercules-ci-agent >hercules-ci-agent.nix
cabal2nix cabal://hercules-ci-api >hercules-ci-api.nix
cabal2nix cabal://hercules-ci-api-agent >hercules-ci-api-agent.nix
cabal2nix cabal://hercules-ci-api-core >hercules-ci-api-core.nix
cabal2nix cabal://hercules-ci-cli >hercules-ci-cli.nix
cabal2nix cabal://hercules-ci-cnix-expr >hercules-ci-cnix-expr.nix
cabal2nix cabal://hercules-ci-cnix-store >hercules-ci-cnix-store.nix
cabal2nix cabal://openapi3 >openapi3.nix
