{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "liburing";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "axboe";
    repo = "liburing";
    rev = "refs/tags/liburing-${version}";
    hash = "sha256-UOhnFT4UKZmPchKxew3vYeKH2oETDVylE1RmJ2hnLq0=";
  };

  separateDebugInfo = true;
  enableParallelBuilding = true;
  # Upstream's configure script is not autoconf generated, but a hand written one.
  setOutputFlags = false;
  dontDisableStatic = true;
  dontAddStaticConfigureFlags = true;
  configureFlags = [
    "--includedir=${placeholder "dev"}/include"
    "--mandir=${placeholder "man"}/share/man"
  ];

  # mysterious link failure
  hardeningDisable = [ "trivialautovarinit" ];

  # Doesn't recognize platform flags
  configurePlatforms = [ ];

  outputs = [
    "out"
    "bin"
    "dev"
    "man"
  ];

  postInstall = ''
    # Always builds both static and dynamic libraries, so we need to remove the
    # libraries that don't match stdenv type.
    rm $out/lib/liburing*${if stdenv.hostPlatform.isStatic then ".so*" else ".a"}

    # Copy the examples into $bin. Most reverse dependency of
    # this package should reference only the $out output
    for file in $(find ./examples -executable -type f); do
      install -Dm555 -t "$bin/bin" "$file"
    done
  '';

  meta = with lib; {
    description = "Userspace library for the Linux io_uring API";
    homepage = "https://github.com/axboe/liburing";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      thoughtpolice
      nickcao
    ];
  };
}
