{
  lib,
  stdenv,
  build2,
  DarwinTools,
  fetchurl,
  libuuid,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? !enableShared,
}:

stdenv.mkDerivation rec {
  pname = "libbutl";
  version = "0.16.0";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchurl {
    url = "https://pkg.cppget.org/1/alpha/build2/libbutl-${version}.tar.gz";
    hash = "sha256-MGL6P/lG2sJdJXZiTcDvdy4jmU+2jYHsvaX4eEO9J2g=";
  };

  nativeBuildInputs =
    [
      build2
    ]
    ++ lib.optionals stdenv.isDarwin [
      DarwinTools
    ];

  patches = [
    # Install missing .h files needed by dependers
    # https://github.com/build2/libbutl/issues/5
    ./install-h-files.patch
  ];

  strictDeps = true;

  # Should be true for anything built with build2,
  # but especially important when bootstrapping
  disallowedReferences = [ build2 ];

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace libbutl/uuid-linux.cxx \
      --replace '"libuuid.so' '"${lib.getLib libuuid}/lib/libuuid.so'
  '';

  build2ConfigureFlags = [
    "config.bin.lib=${build2.configSharedStatic enableShared enableStatic}"
  ];

  doCheck = true;

  meta = with lib; {
    description = "build2 utility library";
    longDescription = ''
      This library is a collection of utilities that are used throughout the
      build2 toolchain.
    '';
    homepage = "https://build2.org/";
    changelog = "https://git.build2.org/cgit/libbutl/log";
    license = licenses.mit;
    maintainers = with maintainers; [ r-burns ];
    platforms = platforms.all;
  };
}
