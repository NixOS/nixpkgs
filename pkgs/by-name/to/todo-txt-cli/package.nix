{
  lib,
  stdenv,
  fetchurl,
}:
let
  version = "2.14.0";
in
stdenv.mkDerivation {
  pname = "todo.txt-cli";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ginatrapani/todo.txt-cli/releases/download/v${version}/todo.txt_cli-${version}.tar.gz";
    sha256 = "sha256-cacD7L95oWPxqpuDHn6g5gNs27Bv38a1w1ArYn77hz0=";
  };

  installPhase = ''
    install -vd $out/bin
    install -vm 755 todo.sh $out/bin
    install -vd $out/share/bash-completion/completions
    install -vm 644 todo_completion $out/share/bash-completion/completions/todo
    install -vd $out/etc/todo
    install -vm 644 todo.cfg $out/etc/todo/config
  '';

  meta = {
    description = "Simple plaintext todo list manager";
    homepage = "http://todotxt.com";
    license = lib.licenses.gpl3;
    mainProgram = "todo.sh";
    platforms = lib.platforms.all;
  };
}
