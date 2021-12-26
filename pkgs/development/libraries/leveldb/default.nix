{ lib, stdenv, fetchFromGitHub, fetchpatch, fixDarwinDylibNames, snappy }:

stdenv.mkDerivation rec {
  pname = "leveldb";
  version = "1.20";

  src = fetchFromGitHub {
    owner = "google";
    repo = "leveldb";
    rev = "v${version}";
    sha256 = "01kxga1hv4wp94agx5vl3ybxfw5klqrdsrb6p6ywvnjmjxm8322y";
  };

  patches = [
    # Re-enable RTTI. Needed for e.g. Ceph to compile properly.
    # See https://github.com/NixOS/nixpkgs/issues/147801,
    # https://github.com/google/leveldb/issues/731,
    # https://lists.ceph.io/hyperkitty/list/dev@ceph.io/thread/K4OSAA4AJS2V7FQI6GNCKCK3IRQDBQRS/.
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/leveldb/raw/e8178670c664e952fdd00f1fc6e3eb28b2c5b6a8/f/0006-revert-no-rtti.patch";
      sha256 = "sha256-d2YAV8O+1VKu3WwgNsWw6Cxg5sUUR+xOlJtA7pTcigQ=";
    })
  ];

  buildInputs = [ snappy ];

  nativeBuildInputs = lib.optional stdenv.isDarwin fixDarwinDylibNames;

  doCheck = true;

  buildFlags = [ "all" ];

  postPatch = lib.optionalString stdenv.hostPlatform.isStatic ''
    # remove shared objects from "all" target
    sed -i '/^all:/ s/$(SHARED_LIBS) $(SHARED_PROGRAMS)//' Makefile
  '';

  installPhase = ''
    runHook preInstall

    install -D -t $out/include/leveldb include/leveldb/*
    install -D helpers/memenv/memenv.h $out/include/leveldb/helpers

    install -D -t $out/lib out-{static,shared}/lib*
    install -D -t $out/bin out-static/{leveldbutil,db_bench}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/google/leveldb";
    description = "Fast and lightweight key/value database library by Google";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
