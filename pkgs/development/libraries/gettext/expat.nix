{ runCommand, gettext, expat, makeWrapper }:

runCommand "gettext-expat-${gettext.name}" { buildInputs = [ makeWrapper ]; } ''
  mkdir $out
  cp -rf ${gettext}/* $out/
  chmod a+w $out/bin
  for p in $out/bin/*; do
    wrapProgram $p --prefix LD_LIBRARY_PATH : ${expat}/lib
  done
''
