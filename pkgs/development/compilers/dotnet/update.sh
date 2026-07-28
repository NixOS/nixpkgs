#!/bin/sh
# shellcheck shell=bash

set -Eeuo pipefail

pkgs/development/compilers/dotnet/binary/update.sh "$@"
pkgs/development/compilers/dotnet/source/update.sh "$@"
