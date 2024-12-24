{
  stdenv,
  lib,
  fetchFromGitHub,
  zsh,
  ncurses,
  nix-update-script,
}:

let
  INSTALL_PATH = "${placeholder "out"}/share/fzf-tab";
in
stdenv.mkDerivation rec {
  pname = "zsh-fzf-tab";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "Aloxaf";
    repo = "fzf-tab";
    rev = "v${version}";
    hash = "sha256-Qv8zAiMtrr67CbLRrFjGaPzFZcOiMVEFLg1Z+N6VMhg=";
  };

  strictDeps = true;
  buildInputs = [ ncurses ];

  # https://github.com/Aloxaf/fzf-tab/issues/337
  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=implicit-int"
    ];
  };

  # this script is modified according to fzf-tab/lib-ftb-build-module
  configurePhase = ''
    runHook preConfigure

    pushd modules

    tar -xf ${zsh.src}
    ln -s $(pwd)/Src/fzftab.c zsh-${zsh.version}/Src/Modules/
    ln -s $(pwd)/Src/fzftab.mdd zsh-${zsh.version}/Src/Modules/

    pushd zsh-${zsh.version}


    if [[ ! -f ./configure ]]; then
      ./Util/preconfig
    fi
    if [[ ! -f ./Makefile ]]; then
      ./configure --disable-gdbm --without-tcsetpgrp
    fi

    popd
    popd

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    pushd modules/zsh-${zsh.version}
    make -j$NIX_BUILD_CORES
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p ${INSTALL_PATH}
    cp -r lib ${INSTALL_PATH}/lib
    install -D fzf-tab.zsh ${INSTALL_PATH}/fzf-tab.zsh
    install -D fzf-tab.plugin.zsh ${INSTALL_PATH}/fzf-tab.plugin.zsh
    pushd modules/zsh-${zsh.version}/Src/Modules
    if [[ -e "fzftab.so" ]]; then
       install -D -t ${INSTALL_PATH}/modules/Src/aloxaf/ fzftab.so
    fi
    if [[ -e "fzftab.bundle" ]]; then
       install -D -t ${INSTALL_PATH}/modules/Src/aloxaf/ fzftab.bundle
    fi
    popd

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/Aloxaf/fzf-tab";
    description = "Replace zsh's default completion selection menu with fzf!";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vonfry ];
    platforms = lib.platforms.unix;
  };
}
