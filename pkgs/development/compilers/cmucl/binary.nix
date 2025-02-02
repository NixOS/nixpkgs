{ lib
, stdenv
, fetchurl
, installShellFiles
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cmucl-binary";
  version = "21d";

  srcs = [
    (fetchurl {
      url = "http://common-lisp.net/project/cmucl/downloads/release/"
            + finalAttrs.version + "/cmucl-${finalAttrs.version}-x86-linux.tar.bz2";
      hash = "sha256-RdctcqPTtQh1Yb3BrpQ8jtRFQn85OcwOt1l90H6xDZs=";
    })
    (fetchurl {
      url = "http://common-lisp.net/project/cmucl/downloads/release/"
            + finalAttrs.version + "/cmucl-${finalAttrs.version}-x86-linux.extra.tar.bz2";
      hash = "sha256-zEmiW3m5VPpFgPxV1WJNCqgYRlHMovtaMXcgXyNukls=";
    })];

  sourceRoot = ".";

  outputs = [ "out" "doc" "man" ];

  nativeBuildInputs = [
    installShellFiles
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -pv $out $doc/share $man
    mv bin lib -t $out
    mv -v doc -t $doc/share
    installManPage man/man1/*

    runHook postInstall
  '';

  postFixup = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/bin/lisp
  '';

  meta = with lib; {
    homepage = "http://www.cons.org/cmucl/";
    description = "The CMU implementation of Common Lisp";
    longDescription = ''
      CMUCL is a free implementation of the Common Lisp programming language
      which runs on most major Unix platforms.  It mainly conforms to the
      ANSI Common Lisp standard.
    '';
    license = licenses.publicDomain;
    maintainers = lib.teams.lisp.members;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
})
