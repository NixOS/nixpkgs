{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtk3,
  Cocoa,
}:

let
  backend = if stdenv.hostPlatform.isDarwin then "darwin" else "unix";
in

stdenv.mkDerivation rec {
  pname = "libui";
  version = "4.1a";
  src = fetchFromGitHub {
    owner = "andlabs";
    repo = "libui";
    rev = "alpha4.1";
    sha256 = "0bm6xvqk4drg2kw6d304x6mlfal7gh8mbl5a9f0509smmdzgdkwm";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  propagatedBuildInputs =
    lib.optional stdenv.hostPlatform.isLinux gtk3
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Cocoa ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i 's/set(CMAKE_OSX_DEPLOYMENT_TARGET "10.8")//' ./CMakeLists.txt
  '';

  installPhase =
    ''
      mkdir -p $out/{include,lib}
      mkdir -p $out/lib/pkgconfig
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      mv ./out/libui.so.0 $out/lib/
      ln -s $out/lib/libui.so.0 $out/lib/libui.so
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mv ./out/libui.A.dylib $out/lib/
      ln -s $out/lib/libui.A.dylib $out/lib/libui.dylib
    ''
    + ''
      cp $src/ui.h $out/include
      cp $src/ui_${backend}.h $out/include

      cp ${./libui.pc} $out/lib/pkgconfig/libui.pc
      substituteInPlace $out/lib/pkgconfig/libui.pc \
        --subst-var-by out $out \
        --subst-var-by version "${version}"
    '';
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -id $out/lib/libui.A.dylib $out/lib/libui.A.dylib
  '';

  meta = with lib; {
    homepage = "https://github.com/andlabs/libui";
    description = "Simple and portable (but not inflexible) GUI library in C that uses the native GUI technologies of each platform it supports";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
