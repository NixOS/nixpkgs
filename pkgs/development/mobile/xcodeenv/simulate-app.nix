{stdenv, xcodewrapper}:
{name, app, device ? "iPhone", baseDir ? ""}:

stdenv.mkDerivation {
  name = stdenv.lib.replaceChars [" "] [""] name;
  buildCommand = ''
    ensureDir $out/bin
    cat > $out/bin/run-test-simulator << "EOF"
    #! ${stdenv.shell} -e

    cd '${app}/${baseDir}/${name}.app'
    "$(readlink "${xcodewrapper}/bin/iPhone Simulator")" -SimulateApplication './${name}' -SimulateDevice '${device}'
    EOF
    chmod +x $out/bin/run-test-simulator
  '';
}

