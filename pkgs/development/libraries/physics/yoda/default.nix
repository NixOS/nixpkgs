{ lib
, stdenv
, fetchurl
, fetchpatch
, python
, root
, makeWrapper
, zlib
, withRootSupport ? false
}:

stdenv.mkDerivation rec {
  pname = "yoda";
  version = "1.9.8";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/yoda/YODA-${version}.tar.bz2";
    hash = "sha256-e8MGJGirulCv8+y4sizmdxlgNgCYkGiO9FM6qn+S5uQ=";
  };

  patches = [
    # A bugfix https://gitlab.com/hepcedar/yoda/-/merge_requests/116
    (fetchpatch {
      url = "https://gitlab.com/hepcedar/yoda/-/commit/ba1275033522c66bc473dfeffae1a7971e985611.diff";
      hash = "sha256-/8UJuypiQzywarE+o3BEMtqM+f+YzkHylugi+xTJf+w=";
      excludes = [ "ChangeLog" ];
    })

    # Fix yodascale for scatters
    (fetchpatch {
      url = "https://gitlab.com/hepcedar/yoda/-/commit/35559c05ec966fe3d5f6c5438c2247e7e1f37dd3.diff";
      hash = "sha256-4skEGwUUBLW1S2S/u74XsuEQxix22qOC+1A0cg1s+cE=";
    })
  ];

  nativeBuildInputs = with python.pkgs; [
    cython
    makeWrapper
  ];

  buildInputs = [
    python
  ] ++ (with python.pkgs; [
    numpy
    matplotlib
  ]) ++ lib.optionals withRootSupport [
    root
  ];

  propagatedBuildInputs = [
    zlib
  ];

  enableParallelBuilding = true;

  postPatch = ''
    touch pyext/yoda/*.{pyx,pxd}
    patchShebangs .

    substituteInPlace pyext/yoda/plotting/script_generator.py \
      --replace '/usr/bin/env python' '${python.interpreter}'
  '';

  postInstall = ''
    for prog in "$out"/bin/*; do
      wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  hardeningDisable = [ "format" ];

  doInstallCheck = true;

  installCheckTarget = "check";

  meta = with lib; {
    description = "Provides small set of data analysis (specifically histogramming) classes";
    license = licenses.gpl3Only;
    homepage = "https://yoda.hepforge.org";
    changelog = "https://gitlab.com/hepcedar/yoda/-/blob/yoda-${version}/ChangeLog";
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
