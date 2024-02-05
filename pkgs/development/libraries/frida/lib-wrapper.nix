# A wrapper for a frida library that applies the weird release engineering
# processes that produce the official devkit shape from a normal shaped meson
# build.
{ platforms
, srcs
, lib
, stdenv
, python3
, fetchFromGitHub
, runCommandCC
, pkg-config
, pcre2
, util-linuxMinimal
, libselinux
, libsepol
, pcre
, glib
}:
{ unwrapped, devkitName, selfDerivation }:
# NOTE: this can change to a direct clone of the newly (2024-01-25, frida commit e53a678b) split out
# releng module when that gets into a release.
let
  inherit (lib) boolToString;
  srcWithReleng = fetchFromGitHub srcs.frida;

  # FIXME(lf-): this is horrible and makes me sad
  # We need to include the transitive dependencies of everything required by pkg-config. I have no
  # idea why these aren't appropriately propagated.
  transitiveDependencies = [
    pcre2
  ] ++ lib.optionals stdenv.isLinux [
    util-linuxMinimal
    libselinux
    # required by libselinux
    pcre
    libsepol
  ];

  # edited from stdenv/generic/make-derivation.nix; this meson stuff is all basically just nonsense
  # to convince the frida packaging that we are not doing crimes
  cpuFamily = platform: with platform;
    if isAarch32 then "arm"
    else if isx86_32 then "x86"
    else platform.uname.processor;

  crossFile = builtins.toFile "cross-file.conf" ''
    [constants]
    common_flags = []
    c_like_flags = []
    linker_flags = []
    cxx_like_flags = []
    cxx_link_flags = []

    [properties]
    needs_exe_wrapper = ${boolToString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform)}

    [host_machine]
    system = '${stdenv.targetPlatform.parsed.kernel.name}'
    cpu_family = '${cpuFamily stdenv.targetPlatform}'
    cpu = '${stdenv.targetPlatform.parsed.cpu.name}'
    endian = ${if stdenv.targetPlatform.isLittleEndian then "'little'" else "'big'"}

    [binaries]
    c = 'cc'
    cpp = 'c++'
    ar = 'ar'
    pkgconfig = 'pkg-config'
    objcopy = 'objcopy'
    nm = 'nm'

    [built-in options]
    c_args = []
    cpp_args = []
    c_link_args = []
  '';

  fridaHost = platforms.platformToFridaHost stdenv.hostPlatform;
in
stdenv.mkDerivation {
  pname = devkitName;
  version = srcs.frida.rev;
  buildInputs = [ unwrapped ] ++ unwrapped.buildInputs ++ transitiveDependencies;
  nativeBuildInputs = [ python3 pkg-config ];

  src = srcWithReleng;
  dontConfigure = true;
  dontBuild = true;

  patches = [
    # devkit.py looks for if headers are relative to the frida source root. This
    # will never be the case due to nix pkg-config putting absolute paths
    # there, so we just hack the script to also accept being relative to an
    # env-var.
    ./devkit-py-use-env-var-path.patch
  ];

  installPhase = ''
    mkdir -p $out

    # make up a build directory that looks like what frida wants and is totally bogus
    mkdir -p build
    ln -s ${crossFile} build/frida-${fridaHost}.txt
    ln -s ${unwrapped} build/frida-${fridaHost}

    python3 releng/devkit.py ${devkitName} ${fridaHost} $out
  '';

  passthru.unwrapped = unwrapped;
  passthru.tests = {
    # verifies that the header can be included without external dependencies
    includeHeader = runCommandCC "include-header-test" { } ''
      echo '#include <${devkitName}.h>' > test.c
      cc -c -isystem ${selfDerivation} test.c
      touch $out
    '';
  };

  # Include all includes within the unwrapped distribution and the build inputs
  # of the unwrapped distribution (chiefly glib).
  env.FRIDA_LIB_ROOTS = builtins.concatStringsSep " " [ unwrapped glib.out glib.dev ];

  meta = unwrapped.meta;
}
