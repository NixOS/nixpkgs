{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, gtk3, Cocoa }:

let
  shortName = "libui";
  version   = "4.1a";
  backend   = if stdenv.isDarwin then "darwin" else "unix";
in

stdenv.mkDerivation {
  name = "${shortName}-${version}";
  src  = fetchFromGitHub {
    owner  = "andlabs";
    repo   = "libui";
    rev    = "alpha4.1";
    sha256 = "0bm6xvqk4drg2kw6d304x6mlfal7gh8mbl5a9f0509smmdzgdkwm";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  propagatedBuildInputs = lib.optional stdenv.isLinux gtk3
    ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  preConfigure = lib.optionalString stdenv.isDarwin ''
    sed -i 's/set(CMAKE_OSX_DEPLOYMENT_TARGET "10.8")//' ./CMakeLists.txt
  '';

  installPhase = ''
    mkdir -p $out/{include,lib}
    mkdir -p $out/lib/pkgconfig
  '' + lib.optionalString stdenv.isLinux ''
    mv ./out/${shortName}.so.0 $out/lib/
    ln -s $out/lib/${shortName}.so.0 $out/lib/${shortName}.so
  '' + lib.optionalString stdenv.isDarwin ''
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
  postInstall = lib.optionalString stdenv.isDarwin ''
    install_name_tool -id $out/lib/${shortName}.A.dylib $out/lib/${shortName}.A.dylib
  '';

  meta = with lib; {
    homepage    = "https://github.com/andlabs/libui";
    description = "Simple and portable (but not inflexible) GUI library in C that uses the native GUI technologies of each platform it supports";
    license     = licenses.mit;
    platforms   = platforms.unix;
  };
}
