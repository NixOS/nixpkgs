{ stdenv, fetchgit, emscriptenfastcomp, python, nodejs, closurecompiler, jre }:

let
  tag = "1.36.4";
  appdir = "share/emscripten";
in

stdenv.mkDerivation rec {
  name = "emscripten-${tag}";

  src = fetchgit {
    url = git://github.com/kripken/emscripten;
    rev = "refs/tags/${tag}";
    sha256 = "02m85xh9qx29kb6v11y072gk8fvyc23964wclr70c69j2gal2qpr";
  };

  buildCommand = '' 
    mkdir -p $out/${appdir}
    cp -r $src/* $out/${appdir}
    chmod -R +w $out/${appdir}
    grep -rl '^#!/usr.*python' $out/${appdir} | xargs sed -i -s 's@^#!/usr.*python.*@#!${python}/bin/python@'
    sed -i -e "s,EM_CONFIG = '~/.emscripten',EM_CONFIG = '$out/${appdir}/config'," $out/${appdir}/tools/shared.py
    sed -i -e 's,^.*did not see a source tree above the LLVM.*$,      return True,' $out/${appdir}/tools/shared.py
    sed -i -e 's,def check_sanity(force=False):,def check_sanity(force=False):\n  return,' $out/${appdir}/tools/shared.py
    mkdir $out/bin
    ln -s $out/${appdir}/{em++,em-config,emar,embuilder.py,emcc,emcmake,emconfigure,emlink.py,emmake,emranlib,emrun,emscons} $out/bin

    echo "EMSCRIPTEN_ROOT = '$out/${appdir}'" > $out/${appdir}/config
    echo "LLVM_ROOT = '${emscriptenfastcomp}'" >> $out/${appdir}/config
    echo "PYTHON = '${python}/bin/python'" >> $out/${appdir}/config
    echo "NODE_JS = '${nodejs}/bin/node'" >> $out/${appdir}/config
    echo "JS_ENGINES = [NODE_JS]" >> $out/${appdir}/config
    echo "COMPILER_ENGINE = NODE_JS" >> $out/${appdir}/config
    echo "CLOSURE_COMPILER = '${closurecompiler}/share/java/compiler.jar'" >> $out/${appdir}/config
    echo "JAVA = '${jre}/bin/java'" >> $out/${appdir}/config
  '';
  meta = with stdenv.lib; {
    homepage = https://github.com/kripken/emscripten;
    description = "An LLVM-to-JavaScript Compiler";
    platforms = platforms.all;
    maintainers = with maintainers; [ qknight ];
    license = licenses.ncsa;
  };
}
