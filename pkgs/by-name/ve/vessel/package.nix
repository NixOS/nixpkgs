{
  lib,
  requireFile,
  pkgsi686Linux,
}:

pkgsi686Linux.stdenv.mkDerivation (finalAttrs: {
  pname = "vessel";
  version = "12082012";

  goBuyItNow = ''
    We cannot download the full version automatically, as you require a license.
    Once you bought a license, you need to add your downloaded version to the nix store.
    You can do this by using "nix-prefetch-url file://\$PWD/vessel-${finalAttrs.version}-bin" in the
    directory where you saved it.
  '';

  src = requireFile {
    message = finalAttrs.goBuyItNow;
    name = "vessel-${finalAttrs.version}-bin";
    hash = "sha256-Jr39PPOIU7Jm4kv0os6EbGTPmJVjxQMH6VVYGmVm/O4=";
  };

  ld_preload = ./isatty.c;

  libPath =
    lib.makeLibraryPath [
      pkgsi686Linux.stdenv.cc.cc
      pkgsi686Linux.stdenv.cc.libc
    ]
    + ":"
    + lib.makeLibraryPath [
      pkgsi686Linux.SDL
      pkgsi686Linux.libpulseaudio
      pkgsi686Linux.alsa-lib
    ];

  buildCommand = ''
    mkdir -p $out/libexec/strangeloop/vessel/
    mkdir -p $out/bin

    # allow scripting of the mojoinstaller
    gcc -fPIC -shared -o isatty.so $ld_preload

    echo @@@
    echo @@@ this next step appears to hang for a while
    echo @@@

    # if we call ld.so $(bin) we don't need to set the ELF interpreter, and save a patchelf step.
    LD_PRELOAD=./isatty.so $(cat $NIX_CC/nix-support/dynamic-linker) $src << IM_A_BOT
    n
    $out/libexec/strangeloop/vessel/
    IM_A_BOT

    # use nix SDL libraries
    rm $out/libexec/strangeloop/vessel/x86/libSDL*
    rm $out/libexec/strangeloop/vessel/x86/libstdc++*

    # props to Ethan Lee (the Vessel porter) for understanding
    # how $ORIGIN works in rpath. There is hope for humanity.
    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $libPath:$out/libexec/strangeloop/vessel/x86/ \
      $out/libexec/strangeloop/vessel/x86/vessel.x86

    # we need to libs to find their deps
    for lib in $out/libexec/strangeloop/vessel/x86/lib* ; do
    patchelf \
      --set-rpath $libPath:$out/libexec/strangeloop/vessel/x86/ \
      $lib
    done

    cat > $out/bin/Vessel << EOW
    #!${pkgsi686Linux.runtimeShell}
    cd $out/libexec/strangeloop/vessel/
    exec ./x86/vessel.x86
    EOW

    chmod +x $out/bin/Vessel
  '';

  meta = {
    description = "Fluid physics based puzzle game";
    longDescription = ''
      Living liquid machines have overrun this world of unstoppable progress,
      and it is the role of their inventor, Arkwright, to stop the chaos they are
      causing. Vessel is a game about a man with the power to bring ordinary matter
      to life, and all the consequences that ensue.
    '';
    homepage = "http://www.strangeloopgames.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ jcumming ];
  };

})
