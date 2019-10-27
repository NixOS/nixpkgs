{ lib
, fetchPypi
, fetchNuGet
, buildPythonPackage
, python
, pytest
, pycparser
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

  NUnit360 = fetchNuGet {
    baseName = "NUnit";
    version = "3.6.0";
    sha256 = "0wz4sb0hxlajdr09r22kcy9ya79lka71w0k1jv5q2qj3d6g2frz1";
    outputFiles = [ "*" ];
  };

in

buildPythonPackage rec {
  pname = "pythonnet";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hxnkrfj8ark9sbamcxzd63p98vgljfvdwh79qj3ac8pqrgghq80";
  };

  postPatch = ''
    substituteInPlace setup.py --replace 'self._install_packages()' '#self._install_packages()'
  '';

  preConfigure = ''
    [ -z "$dontPlacateNuget" ] && placate-nuget.sh
    [ -z "$dontPlacatePaket" ] && placate-paket.sh
  '';

  nativeBuildInputs = [
    pytest
    pycparser

    pkgconfig
    dotnetbuildhelpers
    clang

    NUnit360
    UnmanagedExports127
  ];

  buildInputs = [
    mono
  ];

  preBuild = ''
    rm -rf packages
    mkdir packages

    ln -s ${NUnit360}/lib/dotnet/NUnit/ packages/NUnit.3.6.0
    ln -s ${UnmanagedExports127}/lib/dotnet/NUnit/ packages/UnmanagedExports.1.2.7
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
