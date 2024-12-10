{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  autoconf,
  automake,
  removeReferencesTo,
  libtool,
  python3,
  flex,
  libevent,
  targetPackages,
  makeWrapper,
  hwloc,
  munge,
  zlib,
  pandoc,
  gitMinimal,
}:

stdenv.mkDerivation rec {
  pname = "pmix";
  version = "5.0.1";

  src = fetchFromGitHub {
    repo = "openpmix";
    owner = "openpmix";
    rev = "v${version}";
    hash = "sha256-ZuuzQ8j5zqQ/9mBFEODAaoX9/doWB9Nt9Sl75JkJyqU=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    patchShebangs ./autogen.pl
    patchShebangs ./config
  '';

  nativeBuildInputs = [
    pandoc
    perl
    autoconf
    automake
    libtool
    flex
    gitMinimal
    python3
    removeReferencesTo
    makeWrapper
  ];

  buildInputs = [
    libevent
    hwloc
    munge
    zlib
  ];

  configureFlags = [
    "--with-libevent=${lib.getDev libevent}"
    "--with-libevent-libdir=${lib.getLib libevent}/lib"
    "--with-munge=${munge}"
    "--with-hwloc=${lib.getDev hwloc}"
    "--with-hwloc-libdir=${lib.getLib hwloc}/lib"
  ];

  preConfigure = ''
    ./autogen.pl
  '';

  postInstall = ''
    find $out/lib/ -name "*.la" -exec rm -f \{} \;

    moveToOutput "bin/pmix_info" "''${!outputDev}"
    moveToOutput "bin/pmixcc" "''${!outputDev}"
    moveToOutput "share/pmix/pmixcc-wrapper-data.txt" "''${!outputDev}"

    # The path to the pmixcc-wrapper-data.txt is hard coded and
    # points to $out instead of dev. Use wrapper to fix paths.
    wrapProgram $dev/bin/pmixcc \
      --set PMIX_INCLUDEDIR $dev/include \
      --set PMIX_PKGDATADIR $dev/share/pmix
  '';

  postFixup = ''
    # The build info (parameters to ./configure) are hardcoded
    # into the library. This clears all references to $dev/include.
    remove-references-to -t $dev $(readlink -f $out/lib/libpmix.so)

    # Pin the compiler to the current version in a cross compiler friendly way.
    # Same pattern as for openmpi (see https://github.com/NixOS/nixpkgs/pull/58964#discussion_r275059427).
    sed -i 's:compiler=.*:compiler=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}cc:' \
      $dev/share/pmix/pmixcc-wrapper-data.txt
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Process Management Interface for HPC environments";
    homepage = "https://openpmix.github.io/";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}
