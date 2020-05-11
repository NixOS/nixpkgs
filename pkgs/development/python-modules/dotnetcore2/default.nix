{ stdenv, lib, buildPythonPackage, fetchPypi, python, isPy27
, dotnet-sdk
, substituteAll
, distro
, unzip
}:

buildPythonPackage rec {
  pname = "dotnetcore2";
  version = "2.1.14";
  format = "wheel";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version format;
    python = "py3";
    platform = "manylinux1_x86_64";
    sha256 = "68182f4b704db401b2012c10ed8a19561f8d487063632f8731c2e58960ca9242";
  };

  nativeBuildInputs = [ unzip ];

  propagatedBuildInputs = [ distro ];

  # needed to apply patches
  prePatch = ''
    unzip dist/dotnet*
  '';

  patches = [
    ( substituteAll {
        src = ./runtime.patch;
        dotnet = dotnet-sdk;
      }
    )
  ];

  # prevent exposing a broken dotnet executable
  postInstall = ''
    rm -r $out/${python.sitePackages}/${pname}/bin
  '';

  # no tests, ensure it's one useful function works
  checkPhase = ''
    ${python.interpreter} -c 'from dotnetcore2 import runtime; print(runtime.get_runtime_path())'
  '';

  meta = with lib; {
    description = "DotNet Core runtime";
    homepage = "https://github.com/dotnet/core";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jonringer ];
  };
}
