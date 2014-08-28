{ stdenv, fetchgit, emscriptenfastcomp, python, nodejs, closurecompiler, jre }:

let
  tag = "1.21.0";
in

stdenv.mkDerivation rec {
  name = "emscripten-${tag}";

  src = fetchgit {
    url = git://github.com/kripken/emscripten;
    rev = "refs/tags/${tag}";
    sha256 = "0y17ab4nhd3521b50sv2i2667w0rlcnmlkpkgw5j3fsh8awxgf32";
  };

  buildCommand = ''
    mkdir $out
    cp -a $src $out/bin
    chmod -R +w $out/bin
    grep -rl '^#!/usr.*python' $out/bin | xargs sed -i -s 's@^#!/usr.*python.*@#!${python}/bin/python@'
    sed -i -e "s,EM_CONFIG = '~/.emscripten',EM_CONFIG = '$out/config'," $out/bin/tools/shared.py
    sed -i -e 's,^.*did not see a source tree above the LLVM.*$,      return True,' $out/bin/tools/shared.py
    sed -i -e 's,def check_sanity(force=False):,def check_sanity(force=False):\n  return,' $out/bin/tools/shared.py

    echo "EMSCRIPTEN_ROOT = '$out/bin'" > $out/config
    echo "LLVM_ROOT = '${emscriptenfastcomp}'" >> $out/config
    echo "PYTHON = '${python}/bin/python'" >> $out/config
    echo "NODE_JS = '${nodejs}/bin/node'" >> $out/config
    echo "JS_ENGINES = [NODE_JS]" >> $out/config
    echo "COMPILER_ENGINE = NODE_JS" >> $out/config
    echo "CLOSURE_COMPILER = '${closurecompiler}/bin/closure-compiler'" >> $out/config
    echo "JAVA = '${jre}/bin/java'" >> $out/config
  '';
  meta = with stdenv.lib; {
    homepage = https://github.com/kripken/emscripten;
    description = "An LLVM-to-JavaScript Compiler";
    maintainers = with maintainers; [ bosu ];
    license = with licenses; ncsa;
  };
}
