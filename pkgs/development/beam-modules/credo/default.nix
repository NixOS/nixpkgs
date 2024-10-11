{ lib
, fetchFromGitHub
, makeWrapper
, beamPackages
, elixir
, erlang
, rebar3
, ...
}:

beamPackages.mixRelease rec {
  pname = "credo";
  version = "1.7.4";

  inherit elixir;

  buildInputs = [ erlang ];

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "rrrene";
    repo = "credo";
    rev = "v${version}";
    hash = "sha256-C3/h0nc0r1CWxRwXIccFjlIRdOoh9NyDTV62VZgUU7k=";
  };

  patches = [ ./01-enable-ansi.diff ];

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    sha256 = "sha256-nhTmH5FkZDVbjIVtYSfbQJ44fu/LRLLbGwEE3EriSTs=";
  };

  installPhase = ''
    runHook preInstall

    mix escript.build

    mkdir -p $out/bin
    mv ./credo $out/bin

    runHook postInstall
  '';

  preFixup = ''
    wrapProgram $out/bin/credo \
      --suffix PATH : ${lib.makeBinPath [ elixir ]} \
      --set MIX_REBAR3 ${rebar3}/bin/rebar3
  '';

  meta = with lib; {
    homepage = "http://credo-ci.org/";
    description = "A static code analysis tool for the Elixir language with a focus on code consistency and teaching.";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with lib.maintainers; [ ethnt ];
    mainProgram = "credo";
  };
}
