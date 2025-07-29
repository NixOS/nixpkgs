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
  darwin
}:

let

  # Linux only
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

  pname = "verifast";
  version = "25.06";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/verifast/verifast/releases/download/${version}/${pname}-${version}-linux.tar.gz";
      sha256 = "0nnbma4j8f0ayfqn6spjvb7nqvvx6rzpdhxzkykj0dl5k66l10bh";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/verifast/verifast/releases/download/${version}/${pname}-${version}-macos-aarch.tar.gz";
      sha256 = "1c1ll9kd6yir40py29amqymvd5pqsnvyzqc8ldpsqvsxk6n9b32h";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/verifast/verifast/releases/download/${version}/${pname}-${version}-macos.tar.gz";
      sha256 = "1nl9dalqkkj8hspk22wrvyb8wh34201d63z14hv6b2q09nan2v6y";
    };
  };
in
stdenv.mkDerivation rec {
  inherit pname version;

  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  dontConfigure = true;
  dontStrip = true;

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin darwin.sigtool;

  installPhase =
    ''
      mkdir -p $out/bin
      cp -R bin $out/libexec
    ''
    + (lib.optionalString stdenv.hostPlatform.isLinux ''
      ${patchExe "$out/libexec/verifast"}
      ${patchExe "$out/libexec/vfide"}
      ${patchLib "$out/libexec/libz3.so"}
    '')
    + (lib.optionalString stdenv.hostPlatform.isDarwin ''
      cp -R lib $out/lib
      install_name_tool -change '@executable_path/../lib/libz3.dylib' $out/lib/libz3.dylib $out/libexec/verifast

      install_name_tool -change libz3.dylib $out/lib/libz3.dylib $out/libexec/vfide-core
      ln -s $out/libexec/vfide-core $out/bin/vfide-core

      for f in $out/libexec/vfide-core $out/lib/*.dylib; do
          for old in `otool -L $f | fgrep homebrew | sed -E 's|^[[:space:]]+([^ ]+).*$|\1|g'`; do
              new=`echo $old | sed -E 's|/opt/homebrew/.+/lib/([^ ]+)|\1|'`
              install_name_tool -change $old $out/lib/$new $f
              codesign --force -s - $f
          done
      done
      # include path points to $out/bin
      ln -s $out/libexec/*.{h,gh,cfmanifest,c} $out/bin/
    '')
    + ''
      ln -s $out/libexec/verifast $out/bin/verifast
      ln -s $out/libexec/vfide    $out/bin/vfide
    '';

  meta = {
    description = "Verification for C and Java programs via separation logic";
    homepage = "https://people.cs.kuleuven.be/~bart.jacobs/verifast/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
    platforms = builtins.attrNames srcs;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
