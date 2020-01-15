{ stdenv, fetchgit, cmake, pkgconfig, gtk3, Cocoa }:

let
  shortName = "libui";
  version   = "3.1a";
  backend   = if stdenv.isDarwin then "darwin" else "unix";
in

stdenv.mkDerivation {
  name = "${shortName}-${version}";
  src  = fetchgit {
    url    = "https://github.com/andlabs/libui.git";
    rev    = "6ebdc96b93273c3cedf81159e7843025caa83058";
    sha256 = "1lpbfa298c61aarlzgp7vghrmxg1274pzxh1j9isv8x758gk6mfn";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = stdenv.lib.optional stdenv.isLinux gtk3
    ++ stdenv.lib.optionals stdenv.isDarwin [ Cocoa ];

  preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's/set(CMAKE_OSX_DEPLOYMENT_TARGET "10.8")//' ./CMakeLists.txt
  '';

  installPhase = ''
    mkdir -p $out/{include,lib}
    mkdir -p $out/lib/pkgconfig
  '' + stdenv.lib.optionalString stdenv.isLinux ''
    mv ./out/${shortName}.so.0 $out/lib/
    ln -s $out/lib/${shortName}.so.0 $out/lib/${shortName}.so
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    mv ./out/${shortName}.A.dylib $out/lib/
    ln -s $out/lib/${shortName}.A.dylib $out/lib/${shortName}.dylib
  '' + ''
    cp $src/ui.h $out/include
    cp $src/ui_${backend}.h $out/include

    cp ${./libui.pc} $out/lib/pkgconfig/${shortName}.pc
    substituteInPlace $out/lib/pkgconfig/${shortName}.pc \
      --subst-var-by out $out \
      --subst-var-by version "${version}"
  '';
  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -id $out/lib/${shortName}.A.dylib $out/lib/${shortName}.A.dylib
  '';

  meta = with stdenv.lib; {
    homepage    = https://github.com/andlabs/libui;
    description = "Simple and portable (but not inflexible) GUI library in C that uses the native GUI technologies of each platform it supports.";
    license     = licenses.mit;
    platforms   = platforms.unix;
  };
}
