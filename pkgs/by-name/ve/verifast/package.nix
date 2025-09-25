{
  lib,
  stdenv,
  fetchurl,
  gtk2,
  gdk-pixbuf,
  atk,
  pango,
  glib,
  cairo,
  freetype,
  fontconfig,
  libxml2,
  gnome2,
}:

let

  libPath =
    lib.makeLibraryPath [
      stdenv.cc.libc
      stdenv.cc.cc
      gtk2
      gdk-pixbuf
      atk
      pango
      glib
      cairo
      freetype
      fontconfig
      libxml2
      gnome2.gtksourceview
    ]
    + ":${lib.getLib stdenv.cc.cc}/lib64:$out/libexec";

  patchExe = x: ''
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath} ${x}
  '';

  patchLib = x: ''
    patchelf --set-rpath ${libPath} ${x}
  '';

in
stdenv.mkDerivation rec {
  pname = "verifast";
  version = "25.08";

  src = fetchurl {
    url = "https://github.com/verifast/verifast/releases/download/${version}/${pname}-${version}-linux.tar.gz";
    sha256 = "sha256-HkABnWrdkb9yFByG9AB/L+Hu9n9FPLf7jx9at9MdUJ8=";
  };

  dontConfigure = true;
  dontStrip = true;
  installPhase = ''
    mkdir -p $out/bin
    cp -R bin $out/libexec

    ${patchExe "$out/libexec/verifast"}
    ${patchExe "$out/libexec/vfide"}
    ${patchLib "$out/libexec/libz3.so"}
    ln -s $out/libexec/verifast $out/bin/verifast
    ln -s $out/libexec/vfide    $out/bin/vfide
  '';

  meta = {
    description = "Verification for C and Java programs via separation logic";
    homepage = "https://people.cs.kuleuven.be/~bart.jacobs/verifast/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
