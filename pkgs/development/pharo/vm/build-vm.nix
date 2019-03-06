{ alsaLib
, autoreconfHook
, bash
, cairo
, fetchFromGitHub
, fetchurl
, file
, fontconfig
, freetype
, gcc5
, gdk_pixbuf
, glib
, glibc
, gtk3-x11
, lib
, libGLU_combined
, libgit2
, libmoz2d
, libpng
, libpulseaudio
, libssh2
, libuuid
, libxcb
, libXext
, libXv
, openssl
, pangox_compat
, pixman
, runCommand
, runtimeShell
, SDL2
, squeak
, stdenv
, unzip
, xlibs
, xorg
, ... }:

{ name, src, version, source-date, source-url, ... }:

let libs = [
  alsaLib
  cairo
  file
  fontconfig
  freetype
  gcc5
  gdk_pixbuf
  glib
  gtk3-x11
  libGLU_combined
  libgit2
  libmoz2d
  libpng
  libssh2
  libuuid
  openssl
  pangox_compat
  pixman
  SDL2
  xlibs.libXrender
  xlibs.libxcb
  xlibs.libXext
  xlibs.libXv
  xorg.libICE
  xorg.libSM
  xorg.libXcursor
]; in

# Build the Pharo VM
stdenv.mkDerivation rec {
  inherit name src source-date source-url version;

  # Command line invocation name.
  # Distinct name for 64-bit builds because they only work with 64-bit images.
  cmd = if stdenv.is64bit then "pharo-spur64" else "pharo-spur";

  patches = [
    ./0001-sqUnixHeartbeat.c-Remove-warning-about-thread-priori.patch
  ];

  # Choose desired VM sources. Separate for 32-bit and 64-bit VM.
  # (Could extent to building more VM variants e.g. SpurV3, Sista, etc.)
  vm = if stdenv.is64bit then "spur64src" else "spursrc";
  archbits = if stdenv.is64bit then "64" else "32";

  # Choose target platform name in the format used by the vm.
  flavor =
    if      stdenv.isLinux && stdenv.isi686    then "linux32x86"
    else if stdenv.isLinux && stdenv.isx86_64  then "linux64x64"
    else if stdenv.isDarwin && stdenv.isi686   then "macos32x86"
    else if stdenv.isDarwin && stdenv.isx86_64 then "macos64x64"
    else throw "Unsupported platform: only Linux/Darwin x86/x64 are supported.";

  # Shared data (for the sources file)
  pharo-share = import ./share.nix { inherit stdenv fetchurl unzip; };

  # Note: -fPIC causes the VM to segfault.
  hardeningDisable = [ "format" "pic" "stackprotector" ];

  # Regenerate the configure script.
  # Unnecessary? But the build breaks without this.
  autoreconfPhase = ''
    pushd platforms/unix/config
    make
    popd
  '';

  # Configure with options modeled on the 'mvm' build script from the vm.
  configureScript = "platforms/unix/config/configure";
  configureFlags = [ "--without-npsqueak"
                     "--with-vmversion=5.0"
                     "--with-src=${vm}" ];
  CFLAGS = "-DPharoVM -m${archbits} -DIMMUTABILITY=1 -msse2 -D_GNU_SOURCE -DCOGMTVM=0 -g -O2 -DNDEBUG";
  LDFLAGS = "-Wl,-z,now";
  dontStrip = true;

  # VM sources require some patching before build.
  prePatch = ''
    patchShebangs build.${flavor}
    # Fix hard-coded path to /bin/rm in a script
    sed -i -e 's:/bin/rm:rm:' platforms/unix/config/mkmf
    # Fill in mandatory metadata about the VM source version
    sed -i -e 's!\$Date\$!$Date: ${source-date} $!' \
           -e 's!\$Rev\$!$Rev: ${version} $!' \
           -e 's!\$URL\$!$URL: ${source-url} $!' \
           platforms/Cross/vm/sqSCCSVersion.h
    sed -i "s!/usr/bin/file!${file}/bin/file!g" ${configureScript}
  '';

  # Note: --with-vmcfg configure option is broken so copy plugin specs to ./
  preConfigure = ''
    cp build."${flavor}"/pharo.cog.spur/plugins.{ext,int} .
  '';

  # (No special build phase.)

  installPhase = ''
    # Install in working directory and then copy
    make install-squeak install-plugins prefix=$(pwd)/products
    # Copy binaries & rename from 'squeak' to 'pharo'
    mkdir -p "$out"
    cp products/lib/squeak/5.0-*/squeak "$out/pharo"
    cp -r products/lib/squeak/5.0-*/*.so "$out"
    ln -s "${pharo-share}/lib/"*.sources "$out"
    # Create a shell script to run the VM in the proper environment.
    #
    # These wrapper puts all relevant libraries into the
    # LD_LIBRARY_PATH. This is important because various C code in the VM
    # and Smalltalk code in the image will search for them there.
    mkdir -p "$out/bin"
    # Note: include ELF rpath in LD_LIBRARY_PATH for finding libc.
    libs=$out:$(patchelf --print-rpath "$out/pharo"):${stdenv.lib.makeLibraryPath libs}
    # Create the script
    cat > "$out/bin/${cmd}" <<EOF
    #!${runtimeShell}
    set -f
    LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:$libs" exec $out/pharo "\$@"
    EOF
    chmod +x "$out/bin/${cmd}"
    ln -s ${libgit2}/lib/libgit2.so* "$out/"
    patchelf --set-rpath $(patchelf --print-rpath "$out/pharo"):${libmoz2d}/lib:${freetype}/lib $out/pharo
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook bash unzip glibc openssl gcc5 ] ++ libs;
  buildInputs = [ bash glibc pharo-share unzip ] ++ libs;

  meta = with stdenv.lib; {
    description = "Clean and innovative Smalltalk-inspired environment";
    longDescription = ''
      Pharo's goal is to deliver a clean, innovative, free open-source
      Smalltalk-inspired environment. By providing a stable and small core
      system, excellent dev tools, and maintained releases, Pharo is an
      attractive platform to build and deploy mission critical applications.

      This package provides the executable VM. You should probably not care
      about this package (which represents a packaging detail) and have a
      look at the pharo-vm-core package instead.

      Please fill bug reports on http://bugs.pharo.org under the 'Ubuntu
      packaging (ppa:pharo/stable)' project.
    '';
    homepage = http://pharo.org;
    license = licenses.mit;
    maintainers = [ maintainers.lukego ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
