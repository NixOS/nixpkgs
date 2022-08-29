{ lib, openjdk17, fetchFromGitHub, jetbrains }:

openjdk17.overrideAttrs (oldAttrs: rec {
  pname = "jetbrains-jdk";
  version = "17.0.4-b469.44";

  src = fetchFromGitHub {
    owner = "JetBrains";
    repo = "JetBrainsRuntime";
    rev = "jb${version}";
    sha256 = "sha256-g4VlG99Qtn4VKj7wOoimlqp2HoDk1Vm8mMWhHOS2SMY='#";
  };
  patches = [];
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
    homepage = "https://confluence.jetbrains.com/display/JBR/JetBrains+Runtime";
    inherit (openjdk17.meta) license platforms mainProgram;
    maintainers = with maintainers; [ edwtjo ];
  };
  passthru = oldAttrs.passthru // {
    home = "${jetbrains.jdk}/lib/openjdk";
  };
})
