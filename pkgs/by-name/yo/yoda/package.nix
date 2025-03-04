{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  bash,
  python3,
  root,
  makeWrapper,
  zlib,
  withRootSupport ? false,
}:

stdenv.mkDerivation rec {
  pname = "yoda";
  version = "2.0.3";

  src = fetchFromGitLab {
    owner = "hepcedar";
    repo = pname;
    rev = "yoda-${version}";
    hash = "sha256-No2Lr4nmYNfFnJVpg7xYjd35g12CbQtpW9QMjM3owko=";
  };

  nativeBuildInputs = with python3.pkgs; [
    autoreconfHook
    bash
    cython
    makeWrapper
  ];

  buildInputs =
    [ python3 ]
    ++ (with python3.pkgs; [
      numpy
      matplotlib
    ])
    ++ lib.optionals withRootSupport [ root ];

  propagatedBuildInputs = [ zlib ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-DWITH_OSX";

  strictDeps = true;

  enableParallelBuilding = true;

  postPatch = ''
    touch pyext/yoda/*.{pyx,pxd}
    patchShebangs .

    substituteInPlace pyext/yoda/plotting/script_generator.py \
      --replace '/usr/bin/env python' '${python3.interpreter}'
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

  meta = {
    description = "Provides small set of data analysis (specifically histogramming) classes";
    license = lib.licenses.gpl3Only;
    homepage = "https://yoda.hepforge.org";
    changelog = "https://gitlab.com/hepcedar/yoda/-/blob/yoda-${version}/ChangeLog";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
