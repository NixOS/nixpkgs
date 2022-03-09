{
  lib,
  python3,
  qt6,
  fetchFromGitHub,
}: {
  python-pyside6-hello = python3.pkgs.buildPythonApplication rec {
    pname = "python-pyside6-hello";
    version = "0.0.1";

    src = fetchFromGitHub {
      owner = "GRomR1";
      repo = "python-pyside6-hello";
      rev = "1531b409168ff530300a7fed0c33387c635ff235";
      sha256 = "Y12z8ex/WU/Bc55RidvylPh8wytL8mXMjSMHd433Yos=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      pyside6
    ];

    nativeBuildInputs = [qt6.wrapQtAppsHook];

    postUnpack = ''
      (
      cd $sourceRoot

      # add shebang line
      (
        echo '#! /usr/bin/env python3'
        cat main.py
      ) >${pname}
      rm main.py

      # add setup.py
      cat >setup.py <<'EOF'
      from setuptools import setup
      setup(
        name='${pname}',
        version='${version}',
        scripts=['${pname}'],

        install_requires=['PySide6'],

      )
      EOF
      )
    '';

    dontWrapQtApps = true;
    makeWrapperArgs = [
      "\${qtWrapperArgs[@]}"
    ];

    doCheck = false;

    meta = with lib; {
      description = "PySide6 Hello World app";
      homepage = "https://github.com/GRomR1/python-pyside6-hello";
      license = licenses.mit;
      maintainers = with maintainers; [milahu];
    };
  };
}
