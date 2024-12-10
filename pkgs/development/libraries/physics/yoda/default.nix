{
  lib,
  stdenv,
  fetchurl,
  python,
  root,
  makeWrapper,
  zlib,
  withRootSupport ? false,
}:

stdenv.mkDerivation rec {
  pname = "yoda";
  version = "1.9.10";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/yoda/YODA-${version}.tar.bz2";
    hash = "sha256-CnCO6dcElF0zh8xDexX/3fOCxw/lurOe0r2/g8LCjG8=";
  };

  nativeBuildInputs = with python.pkgs; [
    cython
    makeWrapper
  ];

  buildInputs =
    [
      python
    ]
    ++ (with python.pkgs; [
      numpy
      matplotlib
    ])
    ++ lib.optionals withRootSupport [
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
