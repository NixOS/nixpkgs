{ stdenv, fetchFromGitHub, cmake, makeWrapper
, boost, python3
, icestorm, trellis

# TODO(thoughtpolice) Currently the GUI build seems broken at runtime on my
# laptop (and over a remote X server on my server...), so mark it broken for
# now, with intent to fix later.
, enableGui ? false
, qtbase
}:

let
  boostPython = boost.override { python = python3; enablePython = true; };

  # This is a massive hack. For now, Trellis doesn't really support
  # installation through an already-built package; you have to build it once to
  # get the tools, then reuse the build directory to build nextpnr -- the
  # 'install' phase doesn't install everything it needs.  This will be fixed in
  # the future but for now we can do this horrific thing.
  trellisRoot = trellis.overrideAttrs (_: {
    installPhase = ''
      mkdir -p $out
      cp *.so ..
      cd ../../.. && cp -R trellis database $out/
    '';
  });
in
stdenv.mkDerivation rec {
  name = "nextpnr-${version}";
  version = "2019.02.20";

  src = fetchFromGitHub {
    owner  = "yosyshq";
    repo   = "nextpnr";
    rev    = "e8d3aaaf34895a073e4023192d97fc936d090990";
    sha256 = "0ijqpjnn7x16crd6cmd4nmgay320flizmjb7bbvg9hv464z3p4x7";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs
     = [ boostPython python3 ]
    ++ (stdenv.lib.optional enableGui qtbase);

  enableParallelBuilding = true;
  cmakeFlags =
    [ "-DARCH=generic;ice40;ecp5"
      "-DICEBOX_ROOT=${icestorm}/share/icebox"
      "-DTRELLIS_ROOT=${trellisRoot}/trellis"
    ] ++ (stdenv.lib.optional (!enableGui) "-DBUILD_GUI=OFF");

  # Fix the version number. This is a bit stupid (and fragile) in practice
  # but works ok. We should probably make this overrideable upstream.
  patchPhase = with builtins; ''
    substituteInPlace ./CMakeLists.txt \
      --replace 'git log -1 --format=%h' 'echo ${substring 0 11 src.rev}'
  '';

  postInstall = stdenv.lib.optionalString enableGui ''
    for x in generic ice40 ecp5; do
      wrapProgram $out/bin/nextpnr-$x \
        --prefix QT_PLUGIN_PATH : ${qtbase}/lib/qt-${qtbase.qtCompatVersion}/plugins
    done
  '';

  meta = with stdenv.lib; {
    description = "Place and route tool for FPGAs";
    homepage    = https://github.com/yosyshq/nextpnr;
    license     = licenses.isc;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];

    broken = enableGui;
  };
}
