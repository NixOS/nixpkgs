{ lib
, fetchPypi
, fetchNuGet
, buildPythonPackage
, python
, pytest
, pycparser
, psutil
, pkgconfig
, dotnetbuildhelpers
, clang
, mono
}:

let

  UnmanagedExports127 = fetchNuGet {
    baseName = "UnmanagedExports";
    version = "1.2.7";
    sha256 = "0bfrhpmq556p0swd9ssapw4f2aafmgp930jgf00sy89hzg2bfijf";
    outputFiles = [ "*" ];
  };

  NUnit371 = fetchNuGet {
    baseName = "NUnit";
    version = "3.7.1";
    sha256 = "1yc6dwaam4w2ss1193v735nnl79id78yswmpvmjr1w4bgcbdza4l";
    outputFiles = [ "*" ];
  };

in

buildPythonPackage rec {
  pname = "pythonnet";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ach9jic7a9rd3vmc4bphkr9fq01a0qk81f8a7gr9npwzmkqx8x3";
  };

  postPatch = ''
    substituteInPlace setup.py --replace 'self._install_packages()' '#self._install_packages()'
  '';

  preConfigure = ''
    [ -z "''${dontPlacateNuget-}" ] && placate-nuget.sh
    [ -z "''${dontPlacatePaket-}" ] && placate-paket.sh
  '';

  nativeBuildInputs = [
    pytest
    pycparser

    pkgconfig
    dotnetbuildhelpers
    clang

    mono

    NUnit371
    UnmanagedExports127
  ];

  buildInputs = [
    mono
    psutil # needed for memory leak tests
  ];

  preBuild = ''
    rm -rf packages
    mkdir packages

    ln -s ${NUnit371}/lib/dotnet/NUnit/ packages/NUnit.3.7.1
    ln -s ${UnmanagedExports127}/lib/dotnet/NUnit/ packages/UnmanagedExports.1.2.7

    # Setting TERM=xterm fixes an issue with terminfo in mono: System.Exception: Magic number is wrong: 542
    export TERM=xterm
  '';

  checkPhase = ''
    ${python.interpreter} -m pytest
  '';

  meta = with lib; {
    description = ".Net and Mono integration for Python";
    homepage = https://pythonnet.github.io;
    license = licenses.mit;
    maintainers = with maintainers; [ jraygauthier ];
    broken = true;
  };
}
