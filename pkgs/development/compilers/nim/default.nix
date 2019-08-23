# based on https://github.com/nim-lang/Nim/blob/v0.18.0/.travis.yml

{ stdenv, lib, fetchurl, makeWrapper, nodejs-slim-11_x, openssl, pcre, readline,
  boehmgc, sfml, tzdata, coreutils, sqlite }:

stdenv.mkDerivation rec {
  pname = "nim";
  version = "0.20.2";

  src = fetchurl {
    url = "https://nim-lang.org/download/${pname}-${version}.tar.xz";
    sha256 = "0pibil10x0c181kw705phlwk8bn8dy5ghqd9h9fm6i9afrz5ryp1";
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
    nodejs-slim-11_x tzdata coreutils
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

      # reported upstream: https://github.com/nim-lang/Nim/issues/11435
      ${disableTest} ./tests/misc/tstrace.nim

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
    '';

  checkPhase = ''
    runHook preCheck

    ./koch tests --nim:bin/nim all

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin bin/* koch
    ./koch install $out
    mv $out/nim/bin/* $out/bin/ && rmdir $out/nim/bin
    mv $out/nim/*     $out/     && rmdir $out/nim
    wrapProgram $out/bin/nim \
      --suffix PATH : ${lib.makeBinPath [ stdenv.cc ]}

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Statically typed, imperative programming language";
    homepage = "https://nim-lang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ ehmry peterhoeg ];
    platforms = with platforms; linux ++ darwin; # arbitrary
  };
}
