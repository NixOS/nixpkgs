# Determines whether the Native Code Generation (NCG) backend of the given
# GHC `version` is supported for compiling to `stdenv.targetPlatform`.
{
  version,
  stdenv,
  lib,
}:

stdenv.targetPlatform.isx86
|| stdenv.targetPlatform.isPower
|| (lib.versionOlder version "9.4" && stdenv.targetPlatform.isSparc)
|| (lib.versionAtLeast version "9.2" && stdenv.targetPlatform.isAarch64)
|| (lib.versionAtLeast version "9.6" && stdenv.targetPlatform.isGhcjs)
|| (lib.versionAtLeast version "9.12" && stdenv.targetPlatform.isRiscV64)
