# based on https://github.com/nim-lang/Nim/blob/v0.18.0/.travis.yml

{ stdenv, lib, fetchurl, makeWrapper, nodejs-slim-10_x, openssl, pcre, readline, boehmgc, sfml, tzdata, coreutils }:

stdenv.mkDerivation rec {
  name = "nim-${version}";
  version = "0.19.4";

  src = fetchurl {
    url = "https://nim-lang.org/download/${name}.tar.xz";
    sha256 = "0k59dhfsg5wnkc3nxg5a336pjd9jnfxabns63bl9n28iwdg16hgl";
  };

  doCheck = !stdenv.isDarwin;

  enableParallelBuilding = true;

  NIX_LDFLAGS = [
    "-lcrypto"
    "-lpcre"
    "-lreadline"
    "-lgc"
  ];

  # 1. nodejs is only needed for tests
  # 2. we could create a separate derivation for the "written in c" version of nim
  #    used for bootstrapping, but koch insists on moving the nim compiler around
  #    as part of building it, so it cannot be read-only

  nativeBuildInputs = [
    makeWrapper nodejs-slim-10_x tzdata coreutils
  ];

  buildInputs = [
    openssl pcre readline boehmgc sfml
  ];

  phases = [ "unpackPhase" "patchPhase" "buildPhase" "installPhase" "checkPhase" ];

  buildPhase = ''
    # use $CC to trigger the linker since calling ld in build.sh causes an error
    LD=$CC
    # build.sh wants to write to $HOME/.cache
    HOME=$TMPDIR
    sh build.sh
    ./bin/nim c koch
    ./koch boot  -d:release \
                 -d:useGnuReadline \
                 ${lib.optionals (stdenv.isDarwin || stdenv.isLinux) "-d:nativeStacktrace"}
    ./koch tools -d:release
  '';

  installPhase = ''
    install -Dt $out/bin bin/* koch
    ./koch install $out
    mv $out/nim/bin/* $out/bin/ && rmdir $out/nim/bin
    mv $out/nim/*     $out/     && rmdir $out/nim
    wrapProgram $out/bin/nim \
      --suffix PATH : ${lib.makeBinPath [ stdenv.cc ]}
  '';

  patchPhase =
    let disableTest = ''sed -i '1i discard \"\"\"\n  disabled: true\n\"\"\"\n\n' '';
        disableStdLibTest = ''sed -i -e '/^when isMainModule/,/^END$/{s/^/#/}' '';
        disableCompile = ''sed -i -e 's/^/#/' '';
    in ''
      substituteInPlace ./tests/async/tioselectors.nim --replace "/bin/sleep" "sleep"
      substituteInPlace ./tests/osproc/tworkingdir.nim --replace "/usr/bin" "${coreutils}/bin"
      substituteInPlace ./tests/stdlib/ttimes.nim --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"

      # disable tests requiring network access (not available in the build container)
      ${disableTest} ./tests/stdlib/thttpclient.nim
    '' + lib.optionalString stdenv.isAarch64 ''
      # disable test supposedly broken on aarch64
      ${disableStdLibTest} ./lib/pure/stats.nim
    '';

  checkPhase = ''
    PATH=$PATH:$out/bin
    ./koch tests
  '';

  meta = with stdenv.lib; {
    description = "Statically typed, imperative programming language";
    homepage = https://nim-lang.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ ehmry peterhoeg ];
    platforms = with platforms; linux ++ darwin; # arbitrary
  };
}
