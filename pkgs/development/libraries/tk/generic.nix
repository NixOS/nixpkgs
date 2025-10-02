{
  stdenv,
  lib,
  src,
  pkg-config,
  tcl,
  libXft,
  zip,
  zlib,
  patches ? [ ],
  enableAqua ? stdenv.hostPlatform.isDarwin,
  ...
}:

tcl.mkTclDerivation {
  pname = "tk";
  version = tcl.version;

  inherit src patches;

  outputs = [
    "out"
    "man"
    "dev"
  ];

  setOutputFlags = false;

  preConfigure = ''
    configureFlagsArray+=(--mandir=$man/share/man --enable-man-symlinks)
    cd unix
  '';

  postPatch = ''
    for file in $(find library/demos/. -type f ! -name "*.*"); do
      substituteInPlace $file --replace "exec wish" "exec $out/bin/wish"
    done
  '';

  postInstall =
    let
      # From version 9, the tcl version is included in the lib filename
      libtclstring = lib.optionalString (lib.versionAtLeast tcl.version "9.0") "tcl${lib.versions.major tcl.version}";
      libfile = "$out/lib/lib${libtclstring}tk${tcl.release}${stdenv.hostPlatform.extensions.sharedLibrary}";
    in
    ''
      ln -s $out/bin/wish* $out/bin/wish
      cp ../{unix,generic}/*.h $out/include
      ln -s ${libfile} $out/lib/libtk${stdenv.hostPlatform.extensions.sharedLibrary}
    ''
    + lib.optionalString (stdenv.hostPlatform.isDarwin) ''
      cp ../macosx/*.h $out/include
    '';

  configureFlags = [
    "--enable-threads"
  ]
  ++ lib.optional stdenv.hostPlatform.is64bit "--enable-64bit"
  ++ lib.optional enableAqua "--enable-aqua"
  ++
    lib.optional (lib.versionAtLeast tcl.version "9.0")
      # By default, tk libraries get zipped and embedded into libtcl9tk*.so,
      # which gets `zipfs mount`ed at runtime. This is fragile (for example
      # stripping the .so removes the zip trailer), so we install them as
      # traditional files.
      # This might make tcl slower to start from slower storage on cold cache,
      # however according to my benchmarks on fast storage and warm cache
      # tcl built with --disable-zipfs actually starts in half the time.
      "--disable-zipfs";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals (lib.versionAtLeast tcl.version "9.0") [
    # Only used to detect the presence of zlib. Could be replaced with a stub.
    zip
  ];
  buildInputs = lib.optionals (lib.versionAtLeast tcl.version "9.0") [
    zlib
  ];

  propagatedBuildInputs = [
    libXft
  ];

  enableParallelBuilding = true;

  doCheck = false; # fails. can't find itself

  inherit tcl;

  passthru = rec {
    inherit (tcl) release version;
    libPrefix = "tk${tcl.release}";
    libdir = "lib/${libPrefix}";
  };

  meta = with lib; {
    description = "Widget toolkit that provides a library of basic elements for building a GUI in many different programming languages";
    homepage = "https://www.tcl.tk/";
    license = licenses.tcltk;
    platforms = platforms.all;
    maintainers = [ ];
    broken = stdenv.hostPlatform.isDarwin && lib.elem (lib.versions.majorMinor tcl.version) [ "8.5" ];
  };
}
