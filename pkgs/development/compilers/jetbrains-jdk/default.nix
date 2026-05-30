{
  callPackage,
  fetchurl,
  jetbrains,
  jdk,
  debugBuild ? false,
  withJcef ? true,
  wayland-scanner,
  wayland-protocols,
  libxkbcommon,
}:

let
  gtk-protocols =
    let
      rev = "refs/tags/4.22.1";
      hash = "sha256-zCcXuiEYL2N4Q+WT96ouVDwdZVSohgU/QA2BkGlnZZ0=";
    in
    fetchurl {
      # We only need the wayland protocols file
      url = "https://raw.githubusercontent.com/GNOME/gtk/${rev}/gdk/wayland/protocol/gtk-shell.xml";
      hash = hash;
    };
in
callPackage ./common.nix
  {
    inherit jdk debugBuild withJcef;
  }
  {
    # To get the new tag:
    # git clone https://github.com/jetbrains/jetbrainsruntime
    # cd jetbrainsruntime
    # git tag --points-at [revision]
    # Look for the line that starts with jbr-
    javaVersion = "25.0.2";
    build = "329.72";
    # run `git log -1 --pretty=%ct` in jdk repo for new value on update
    sourceDateEpoch = 1769205294;
    srcHash = "sha256-K4Izbij+1YO4UERHS0mwGKZX/VtIaxyNPZD068Vf99Q=";
    homePath = "${jetbrains.jdk}/lib/openjdk";
    jcefPackage = jetbrains.jcef;
    extraBuildPhase = ''
      cp -r ${gtk-protocols.out} gtk-shell.xml
    '';
    vendorVersionString = "nix/JBR-25.0.2-b329.72${if withJcef then "-jcef" else ""}";
    extraConfigureFlags = [
      "--with-wayland-protocols=${wayland-protocols.out}/share/wayland-protocols"
    ];
    extraNativeBuildInputs = [
      wayland-scanner
      libxkbcommon
    ];
  }
