{
  lib,
  stdenv,
  bundlerEnv,
  ruby,
  fetchFromGitHub,
}:
let
  version = "1.1";
  gems = bundlerEnv {
    name = "tree-from-tags-${version}-gems";
    inherit ruby;
    gemdir = ./.;
  };
in
stdenv.mkDerivation {
  pname = "tree-from-tags";
  inherit version;

  src = fetchFromGitHub {
    owner = "dbrock";
    repo = "bongo";
    rev = version;
    hash = "sha256-G+6rRJLNBECxGc8WuaesXhrYqvEDy2Chpw4lWxO8X9s=";
  };

  buildInputs = [
    gems
    ruby
  ];

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp tree-from-tags.rb $out/share/
    bin=$out/bin/tree-from-tags
    # we are using bundle exec to start in the bundled environment
    cat > $bin <<EOF
    #!/bin/sh -e
    exec ${gems}/bin/bundle exec ${ruby}/bin/ruby "$out"/share/tree-from-tags.rb "\$@"
    EOF
    chmod +x $bin
  '';

  meta = {
    description = "Create file hierarchies from media tags";
    homepage = "https://www.emacswiki.org/emacs/Bongo";
    platforms = ruby.meta.platforms;
    maintainers = with lib.maintainers; [
      livnev
      dbrock
    ];
    license = lib.licenses.gpl2Plus;
    mainProgram = "tree-from-tags";
  };
}
