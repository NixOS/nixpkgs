# based on https://github.com/nim-lang/Nim/blob/v0.18.0/.travis.yml

{ stdenv, lib, fetchurl, makeWrapper, nodejs-slim-8_x, openssl, pcre, readline, sqlite, boehmgc, sfml, tzdata, coreutils }:

stdenv.mkDerivation rec {
  name = "nim-${version}";
  version = "0.18.0";

  src = fetchurl {
    url = "https://nim-lang.org/download/${name}.tar.xz";
    sha256 = "45c74adb35f08dfa9add1112ae17330e5d902ebb4a36e7046caee8b79e6f3bd0";
  };

  doCheck = !stdenv.isDarwin;

  enableParallelBuilding = true;

  NIX_LDFLAGS = [
    "-lcrypto"
    "-lpcre"
    "-lreadline"
    "-lsqlite3"
    "-lgc"
  ];

  # 1. nodejs is only needed for tests
  # 2. we could create a separate derivation for the "written in c" version of nim
  #    used for bootstrapping, but koch insists on moving the nim compiler around
  #    as part of building it, so it cannot be read-only

  buildInputs = [
    makeWrapper nodejs-slim-8_x tzdata coreutils
    openssl pcre readline sqlite boehmgc sfml
  ];

  buildPhase = ''
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

  postPatch =
    let disableTest = ''sed -i '1i discard \"\"\"\n  disabled: true\n\"\"\"\n\n' '';
        disableCompile = ''sed -i -e 's/^/#/' '';
    in ''
      substituteInPlace ./tests/async/tioselectors.nim --replace "/bin/sleep" "sleep"
      substituteInPlace ./tests/osproc/tworkingdir.nim --replace "/usr/bin" "${coreutils}/bin"
      substituteInPlace ./tests/stdlib/ttimes.nim --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"

      # disable supposedly broken tests
      ${disableTest} ./tests/errmsgs/tproper_stacktrace2.nim
      ${disableTest} ./tests/vm/trgba.nim

      # disable tests requiring network access (not available in the build container)
      ${disableTest} ./tests/stdlib/thttpclient.nim
      ${disableTest} ./tests/cpp/tasync_cpp.nim
      ${disableTest} ./tests/niminaction/Chapter7/Tweeter/src/tweeter.nim

      # disable tests requiring un-downloadable dependencies (using nimble, which isn't available in the fetch phase)
      ${disableCompile} ./tests/manyloc/keineschweine/keineschweine.nim
      ${disableTest} ./tests/manyloc/keineschweine/keineschweine.nim
      ${disableCompile} ./tests/manyloc/nake/nakefile.nim
      ${disableTest} ./tests/manyloc/nake/nakefile.nim
      ${disableCompile} ./tests/manyloc/named_argument_bug/main.nim
      ${disableTest} ./tests/manyloc/named_argument_bug/main.nim
    '';

  checkPhase = ''
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
