{
  stdenv,
  lib,
  ruby_3_4,
  bundlerEnv,
  bundlerApp,
  bundlerUpdateScript,
  installShellFiles,
}:

let
  ttBundlerApp = (bundlerApp.override { ruby = ruby_3_4; }) {
    pname = "timetrap";
    gemdir = ./.;
    exes = [
      "t"
      "timetrap"
    ];

    passthru.updateScript = bundlerUpdateScript "timetrap";
  };

  ttGem = (bundlerEnv.override { ruby = ruby_3_4; }) {
    pname = "timetrap";
    gemdir = ./.;
  };

in

stdenv.mkDerivation {
  name = "timetrap";

  dontUnpack = true;

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    mkdir $out
    cd $out

    mkdir bin; pushd bin
    ln -vs ${ttBundlerApp}/bin/t
    ln -vs ${ttBundlerApp}/bin/timetrap
    popd

    for c in t timetrap; do
      installShellCompletion --cmd $c --bash ${ttGem}/lib/ruby/gems/*/gems/timetrap*/completions/bash/*
      installShellCompletion --cmd $c --zsh ${ttGem}/lib/ruby/gems/*/gems/timetrap*/completions/zsh/*
    done
  '';

<<<<<<< HEAD
  meta = {
    description = "Simple command line time tracker written in ruby";
    homepage = "https://github.com/samg/timetrap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Simple command line time tracker written in ruby";
    homepage = "https://github.com/samg/timetrap";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      jerith666
      manveru
      nicknovitski
    ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  passthru = {
    updateScript = ttBundlerApp.passthru.updateScript;
  };
}
