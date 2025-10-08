{
  bash,
  buildHex,
  buildRebar3,
  config,
  coreutils,
  erlang,
  fetchFromGitHub,
  lib,
  makeWrapper,
}:

let
  inherit (lib)
    assertMsg
    makeBinPath
    getVersion
    versionAtLeast
    versions
    ;

  version = "2.2.0";
  hash = "sha256-47lEUVU9Api1Yj1q+Ch8aIV8kaALhst1ty8RHTwMVcI=";

  maximumOTPVersion = "27";
  mainVersion = versions.major (getVersion erlang);
  maxAssert = versionAtLeast maximumOTPVersion mainVersion;

  proper = buildHex {
    name = "proper";
    version = "1.4.0";

    sha256 = "sha256-GChYQhhb0z772pfRNKXLWgiEOE2zYRn+4OPPpIhWjLs=";
  };

in
if !config.allowAliases && !maxAssert then
  # Don't throw without aliases to not break CI.
  null
else
  assert assertMsg maxAssert ''
    LFE ${version} is supported on OTP <=${maximumOTPVersion}, not ${mainVersion}.
  '';
  buildRebar3 {
    name = "lfe";
    inherit version;

    src = fetchFromGitHub {
      owner = "lfe";
      repo = "lfe";
      tag = "v${version}";
      inherit hash;
    };

    patches = [
      ./fix-rebar-config.patch
      ./dedup-ebins.patch
    ];

    nativeBuildInputs = [
      makeWrapper
      erlang
    ];

    beamDeps = [ proper ];

    makeFlags = [
      "-e"
      "MANDB=''"
      "PREFIX=$$out"
    ];

    # override buildRebar3's install to let the builder use make install
    installPhase = "";

    doCheck = true;
    checkTarget = "travis";

    postFixup = ''
      # LFE binaries are shell scripts which run erl and lfe.
      # Add some stuff to PATH so the scripts can run without problems.
      for f in $out/bin/*; do
        wrapProgram $f \
          --prefix PATH ":" "${
            makeBinPath [
              erlang
              coreutils
              bash
            ]
          }:$out/bin"
        substituteInPlace $f --replace "/usr/bin/env" "${coreutils}/bin/env"
      done
    '';

    meta = with lib; {
      description = "Best of Erlang and of Lisp; at the same time";
      longDescription = ''
        LFE, Lisp Flavoured Erlang, is a lisp syntax front-end to the Erlang
        compiler. Code produced with it is compatible with "normal" Erlang
        code. An LFE evaluator and shell is also included.
      '';

      homepage = "https://lfe.io";
      downloadPage = "https://github.com/lfe/lfe/releases";
      changelog = "https://github.com/lfe/lfe/releases/tag/v${version}";

      license = licenses.asl20;
      teams = [ teams.beam ];
      platforms = platforms.unix;
    };
  }
