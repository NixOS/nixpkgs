# When cross-compiling we provide a second set of cmake flags for "native" (to the builder) configuration.

# This file is mostly concerned with:
# * specifying "toolchain" details for build-native use, via conventional cmake variables like CMAKE_C_COMPILER
# * generating a single string that contains these flags and any other options needed

{ lib, buildCC }:

lib.makeOverridable (

{
  extraFlagAttrs ? {},
}:

let
  getPrefixed = pkg: prefix: name: "${lib.getBin pkg}/bin/${prefix}${name}";

  getBuildCCBin = getPrefixed buildCC buildCC.targetPrefix;
  getBuildBin = getPrefixed buildCC.bintools.bintools buildCC.targetPrefix;
  genCMakeFlag = n: v: "-D${n}=${v}";

  toolchainFlagAttrs = {
    # Toolchain
    CMAKE_C_COMPILER = getBuildCCBin "cc";
    CMAKE_CXX_COMPILER = getBuildCCBin "c++";
    CMAKE_AR = getBuildBin "ar";
    CMAKE_RANLIB = getBuildBin "ranlib";
    CMAKE_STRIP = getBuildBin "strip";
  };
  commonFlagAttrs = {
    # Disable LLVM bits that are unneeded or cause breakage
    COMPILER_RT_INCLUDE_TESTS = "OFF";
    LLVM_INCLUDE_TESTS = "OFF";
    LLVM_BUILD_RUNTIME = "OFF";
    # Don't try to build compiler-rt in the native variant
    LLVM_BUILD_EXTERNAL_COMPILER_RT = "ON";
  };
  nativeFlagAttrs = toolchainFlagAttrs // commonFlagAttrs // extraFlagAttrs;
  nativeFlags = lib.mapAttrsToList genCMakeFlag nativeFlagAttrs;

  nativeFlagStr = lib.concatStringsSep ";" nativeFlags;
in
  nativeFlagStr
) {}
