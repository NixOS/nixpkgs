{ lib
, stdenv
, fetchzip
, callPackage
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "qbe";
  version = "1.2";

  src = fetchzip {
    url = "https://c9x.me/compile/release/qbe-${finalAttrs.version}.tar.xz";
    hash = "sha256-UgtJnZF/YtD54OBy9HzGRAEHx5tC9Wo2YcUidGwrv+s=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  passthru = {
    tests.can-run-hello-world = callPackage ./test-can-run-hello-world.nix { };
  };

  meta = with lib; {
    homepage = "https://c9x.me/compile/";
    description = "A small compiler backend written in C";
    maintainers = with maintainers; [ fgaz ];
    license = licenses.mit;
    platforms = platforms.all;
    mainProgram = "qbe";
  };
})
