# based on https://github.com/nim-lang/Nim/blob/v0.18.0/.travis.yml

{ stdenv, lib, fetchurl, makeWrapper, nodejs-slim, openssl, pcre, readline,
  boehmgc, sfml, tzdata, coreutils, sqlite }:

stdenv.mkDerivation rec {
  pname = "nim";
  version = "1.0.0";

  src = fetchurl {
    url = "https://nim-lang.org/download/${pname}-${version}.tar.xz";
    sha256 = "1pg0lxahis8zfk6rdzdj281bahl8wglpjgngkc4vg1pc9p61fj03";
  };

  doCheck = !stdenv.isDarwin;

  enableParallelBuilding = true;

  NIX_LDFLAGS = [
    "-lcrypto"
    "-lpcre"
    "-lreadline"
    "-lgc"
    "-lsqlite3"
  ];

  # 1. nodejs is only needed for tests
  # 2. we could create a separate derivation for the "written in c" version of nim
  #    used for bootstrapping, but koch insists on moving the nim compiler around
  #    as part of building it, so it cannot be read-only

  checkInputs = [
    nodejs-slim tzdata coreutils
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    openssl pcre readline boehmgc sfml sqlite
  ];

  buildPhase = ''
    runHook preBuild

    # build.sh wants to write to $HOME/.cache
    HOME=$TMPDIR
    sh build.sh
    ./bin/nim c koch
    ./koch boot  -d:release \
                 -d:useGnuReadline \
                 ${lib.optionals (stdenv.isDarwin || stdenv.isLinux) "-d:nativeStacktrace"}
    ./koch tools -d:release

    runHook postBuild
  '';

  prePatch =
    let disableTest = ''sed -i '1i discard \"\"\"\n  disabled: true\n\"\"\"\n\n' '';
        disableStdLibTest = ''sed -i -e '/^when isMainModule/,/^END$/{s/^/#/}' '';
        disableCompile = ''sed -i -e 's/^/#/' '';
    in ''
      substituteInPlace ./tests/osproc/tworkingdir.nim --replace "/usr/bin" "${coreutils}/bin"
      substituteInPlace ./tests/stdlib/ttimes.nim --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"

      # runs out of memory on a machine with 8GB RAM
      ${disableTest} ./tests/system/t7894.nim

      # requires network access (not available in the build container)
      ${disableTest} ./tests/stdlib/thttpclient.nim
    '' + lib.optionalString stdenv.isAarch64 ''
      # supposedly broken on aarch64
      ${disableStdLibTest} ./lib/pure/stats.nim

      # reported upstream: https://github.com/nim-lang/Nim/issues/11463
      ${disableCompile} ./lib/nimhcr.nim
      ${disableTest} ./tests/dll/nimhcr_unit.nim
      ${disableTest} ./tests/dll/nimhcr_integration.nim

      # reported upstream: https://github.com/nim-lang/Nim/issues/12262
      ${disableTest} ./tests/range/tcompiletime_range_checks.nim

      # requires "immintrin.h" which is available only on x86
      ${disableTest} ./tests/misc/tsizeof3.nim
    '';

  checkPhase = ''
    runHook preCheck

    # Fortify hardening breaks tests
    # https://github.com/nim-lang/Nim/issues/11435#issuecomment-534545696
    NIX_HARDENING_ENABLE=''${NIX_HARDENING_ENABLE/fortify/} \
    ./koch tests --nim:bin/nim all

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin bin/* koch
    ./koch install $out
    mv $out/nim/bin/* $out/bin/ && rmdir $out/nim/bin
    mv $out/nim/*     $out/     && rmdir $out/nim

    # Fortify hardening appends -O2 to gcc flags which is unwanted for unoptimized nim builds.
    wrapProgram $out/bin/nim \
      --run 'NIX_HARDENING_ENABLE=''${NIX_HARDENING_ENABLE/fortify/}' \
      --suffix PATH : ${lib.makeBinPath [ stdenv.cc ]}

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Statically typed, imperative programming language";
    homepage = "https://nim-lang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ ehmry ];
    platforms = with platforms; linux ++ darwin; # arbitrary
  };
}
