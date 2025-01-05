{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  bash,
  python,
  root,
  makeWrapper,
  zlib,
  withRootSupport ? false,
}:

stdenv.mkDerivation rec {
  pname = "yoda";
  version = "2.0.2";

  src = fetchFromGitLab {
    owner = "hepcedar";
    repo = pname;
    rev = "yoda-${version}";
    hash = "sha256-sHvwgLH22fvdlh4oLjr4fzZ2WtBJMAlvr4Vxi9Xdf84=";
  };

  nativeBuildInputs = with python.pkgs; [
    autoreconfHook
    bash
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

  strictDeps = true;

  enableParallelBuilding = true;

  postPatch = ''
    touch pyext/yoda/*.{pyx,pxd}
    patchShebangs .

    substituteInPlace pyext/yoda/plotting/script_generator.py \
      --replace '/usr/bin/env python' '${python.interpreter}'
  '';

  postInstall = ''
    patchShebangs --build $out/bin/yoda-config
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
