#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash bundix bundler

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

rm -f Gemfile.lock Gemfile.lock

# Otherwise nokogiri will fail to build.
# https://github.com/nix-community/bundix/issues/88
bundler config set --local force_ruby_platform true

bundler lock
BUNDLE_GEMFILE=Gemfile bundler lock --lockfile=Gemfile.lock
bundix --gemfile=Gemfile --lockfile=Gemfile.lock --gemset=gemset.nix
