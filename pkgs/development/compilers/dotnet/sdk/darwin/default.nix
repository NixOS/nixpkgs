{ stdenv
, fetchurl
, darwin
, curl
, libcxx
, zlib
}:

let
  inherit (darwin.apple_sdk.frameworks) Security GSS CoreFoundation CoreServices;
in
stdenv.mkDerivation rec {
  version = "2.2.402";
  netCoreVersion = "2.2.7";
  pname = "dotnet-sdk";

  src = fetchurl {
    url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-osx-x64.tar.gz";
    sha512 = "37p06fmqmym0a41j7nifmz9i8s0lnhdj7kfcz0wn0iyzakjkah6wbg1xv6vl3iq86dcnrql9qnzl2aqbazdrhm7qpgga4g4r8sryxf5";
  };

  sourceRoot = ".";

  buildPhase = ''
    runHook preBuild

    find -type f -name "*.dylib" -exec install_name_tool \
      -change /usr/lib/libSystem.B.dylib ${stdenv.cc.libc}/lib/libSystem.B.dylib \
      -change /usr/lib/libc++.1.dylib ${libcxx}/lib/libc++.1.dylib \
      -change /usr/lib/libz.1.dylib ${zlib}/lib/libz.1.dylib \
      -change /usr/lib/libcurl.4.dylib ${curl}/lib/libcurl.4.dylib \
      -change /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation \
        ${CoreFoundation}/Library/Frameworks/CoreFoundation.framework/CoreFoundation \
      -change /System/Library/Frameworks/CoreServices.framework/Versions/A/CoreServices \
        ${CoreServices}/Library/Frameworks/CoreServices.framework/CoreServices \
      -change /System/Library/Frameworks/Security.framework/Versions/A/Security \
        ${Security}/Library/Frameworks/Security.framework/Security \
      -change /System/Library/Frameworks/GSS.framework/Versions/A/GSS \
        ${GSS}/Library/Frameworks/GSS.framework/GSS {} \;

    install_name_tool \
      -change /usr/lib/libc++.1.dylib ${libcxx}/lib/libc++.1.dylib \
      -change /usr/lib/libSystem.B.dylib ${stdenv.cc.libc}/lib/libSystem.B.dylib \
      ./dotnet

    echo -n "dotnet-sdk version: "
    ./dotnet --version
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r ./ $out
    ln -s $out/dotnet $out/bin/dotnet
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = https://dotnet.github.io/;
    description = ".NET Core SDK ${version} with .NET Core ${netCoreVersion}";
    platforms = platforms.darwin;
    maintainers = with maintainers; [ reset ];
    license = licenses.mit;
  };
}
