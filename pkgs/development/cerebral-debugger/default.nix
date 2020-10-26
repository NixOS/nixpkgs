{ stdenv
, fetchurl
, makeWrapper
, electron_4
}:

stdenv.mkDerivation rec {

  pname = "cerebral-debugger";
  version = "3.1.0";

  src = fetchurl {
    url = "https://github.com/cerebral/cerebral-debugger/releases/download/v${version}/cerebral-debugger-${version}.tar.gz";
    sha256 = "0s4wlbcx1kjrpqkb8a8pljjiylq99s6a80ibr03lkq5r4rw2nw58";
  };

  dontBuild = true;
  dontStrip = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ electron_4 ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/${pname}}
    cp -r resources $out/opt/${pname}
    cp -r locales $out/opt/${pname}
    mv resources/app.asar $out/opt/${pname}

    makeWrapper ${electron_4}/bin/electron $out/bin/${pname} \
      --add-flags $out/opt/${pname}/app.asar

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Powerful development tool for Cerebral";
    longDescription = ''
      Cerebral is a javascript library, which goal is to support
      building gui's using declarative code. The concept is built
      around storing, rendering and updating states. In this regard,
      it is almost impossible to develop using this library without also
      having cerebral-debugger available. The Cerebral Debugger makes it
      easy to trace all state changes over time, and to see the state value
      at any particular time.
    '';
    homepage = "https://github.com/cerebral/cerebral-debugger";
    license = licenses.mit;
    maintainers = with maintainers; [ scalavision ];
    platforms = platforms.linux;
  };
}
