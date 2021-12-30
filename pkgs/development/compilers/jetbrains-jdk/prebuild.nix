{ lib, openjdk11, fetchurl, jetbrains, stdenv }:

openjdk11.overrideAttrs (oldAttrs: rec {
  pname = "jetbrains-jdk";
  version = "1751.21";
  darwinVersion = if stdenv.isAarch64 then "11_0_13-osx-aarch64-b${version}" else "11_0_13-osx-x64-b${version}"; 
  src = fetchurl {
    url = "https://cache-redirector.jetbrains.com/intellij-jbr/jbrsdk-${darwinVersion}.tar.gz";
    sha256 = "sha256-ZU3TEm5n3oYFp82Uo+vHEzZcwdY6thVt1l8CSbBk43o=";
  };
  patches = [];
  
  unpackCmd = "mkdir jdk; pushd jdk; tar -xzf $src; popd";
  installPhase = ''
    cd ..;
    mv $sourceRoot/jbrsdk $out;
  '';  
  
  postFixup = ''
  '';  

  meta = with lib; {
    description = "An OpenJDK fork to better support Jetbrains's products.";
    longDescription = ''
      JetBrains Runtime is a runtime environment for running IntelliJ Platform
      based products on Windows, Mac OS X, and Linux. JetBrains Runtime is
      based on OpenJDK project with some modifications. These modifications
      include: Subpixel Anti-Aliasing, enhanced font rendering on Linux, HiDPI
      support, ligatures, some fixes for native crashes not presented in
      official build, and other small enhancements.

      JetBrains Runtime is not a certified build of OpenJDK. Please, use at
      your own risk.
    '';
    homepage = "https://confßluence.jetbrains.com/display/JBR/JetBrains+Runtime";
    inherit (openjdk11.meta) license platforms mainProgram;
    maintainers = with maintainers; [ edwtjo petabyteboy ];
  };
  passthru = oldAttrs.passthru // {
    home = "${jetbrains.jdk}/Contents/Home";
  };
})
