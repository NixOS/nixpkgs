{ openjdk11, lib }:
with lib; {
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
  homepage = "https://confluence.jetbrains.com/display/JBR/JetBrains+Runtime";
  inherit (openjdk11.meta) license platforms mainProgram;
  maintainers = with maintainers; [ edwtjo ];
}
