{
  lib,
  stdenv,
  build2,
  fetchurl,
  libbutl,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? !enableShared,
}:

stdenv.mkDerivation rec {
  pname = "libbpkg";
  version = "0.16.0";
  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchurl {
    url = "https://pkg.cppget.org/1/alpha/build2/libbpkg-${version}.tar.gz";
    hash = "sha256-h3Stt1n1057ASf3n16plr5cNGIKOjHiiuOfqrcCJ5tA=";
  };

  nativeBuildInputs = [
    build2
  ];
  buildInputs = [
    libbutl
  ];

  build2ConfigureFlags = [
    "config.bin.lib=${build2.configSharedStatic enableShared enableStatic}"
  ];

  strictDeps = true;

  doCheck = true;

  meta = with lib; {
    description = "build2 package dependency manager utility library";
    longDescription = ''
      This library defines the types and utilities for working with build2 packages.
      In particular, it provides C++ classes as well as the parser and serializer
      implementations that can be used to read, manipulate, and write package,
      repository and signature manifests.
    '';
    homepage = "https://build2.org/";
    changelog = "https://git.build2.org/cgit/libbpkg/log";
    license = licenses.mit;
    maintainers = with maintainers; [ r-burns ];
    platforms = platforms.all;
  };
}
