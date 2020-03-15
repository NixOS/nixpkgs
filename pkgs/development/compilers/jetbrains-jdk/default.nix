{ stdenv, openjdk12, fetchFromGitHub, jetbrains }:

openjdk12.overrideAttrs (oldAttrs: rec {
  pname = "jetbrains-jdk";
  version = "11.0.6-b774";
  src = fetchFromGitHub {
    owner = "JetBrains";
    repo = "JetBrainsRuntime";
    rev = "jb${stdenv.lib.replaceStrings ["."] ["_"] version}";
    sha256 = "0lx3h74jwa14kr8ybwxbzc4jsjj6xnymvckdsrhqhvrciya7bxzw";
  };
  patches = [];
  meta = with stdenv.lib; {
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
    homepage = "https://bintray.com/jetbrains/intellij-jdk/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ edwtjo petabyteboy ];
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" "armv7l-linux" "armv6l-linux" ];
  };
  passthru = oldAttrs.passthru // {
    home = "${jetbrains.jdk}/lib/openjdk";
  };
})
