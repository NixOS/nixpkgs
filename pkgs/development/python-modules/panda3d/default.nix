{ lib
, stdenv
, buildPythonPackage
, fetchurl
, python
, isPy37
, isPy38
, isPy39
, autoPatchelfHook
, libXext
, libGL
, gdk-pixbuf
, cairo
, pango }:

let pyVerNoDot = builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
    version = "1.10.10";
    srcs = import ./binary-hashes.nix version;
    unsupported = throw "Unsupported system";
in buildPythonPackage rec {
  pname = "panda3d";

  inherit version;

  format = "wheel";

  src = fetchurl srcs."${stdenv.system}-${pyVerNoDot}" or unsupported;

  disabled = !(isPy37 || isPy38 || isPy39);

  # NOTE(breakds): Panda3d comes with a set of binary tools. There is one tool
  # called `pstats` that I cannot find proper libraries to patchelf it. Since it
  # does not affect using panda3d as a library, remove it before applying
  # patchelf.
  postInstall = ''
   rm $out/lib/python${python.pythonVersion}/site-packages/panda3d_tools/pstats
  '';

  buildInputs = [
    stdenv.cc.cc.lib
    libXext
    libGL
    gdk-pixbuf
    cairo
    pango
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  pythonImportsCheck = [ "panda3d" "panda3d.core" ];

  meta = with lib; {
    homepage = "https://www.panda3d.org";
    description = ''
      Powerful, mature open-source cross-platform game engine for
      Python and C++, developed by Disney and CMU
    '';
    changelog = "https://github.com/panda3d/panda3d/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ breakds ];
    platforms = platforms.linux;
  };
}
